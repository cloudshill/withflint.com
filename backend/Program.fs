namespace withflint.com.backend

module Program =
    open System
    open System.IO
    open System.Net.Mail
    open System.Threading

    open Microsoft.AspNetCore.Builder
    open Microsoft.AspNetCore.Hosting
    open Microsoft.Extensions.Hosting
    open Microsoft.Extensions.DependencyInjection
    open Microsoft.AspNetCore.Http
    open Microsoft.Extensions.FileProviders
    open Microsoft.AspNetCore.Rewrite

    open Giraffe
    open FSharp.Data
    open FSharp.Control.Tasks.Affine
    open FSharp.Text.RegexProvider

    type Job =
        { Url: String
          Title: String
          Location: String
          Equity: String
          Experience: String }

    type JobRegex =
        Regex< @"(?<Url>https://www.ycombinator.com/companies/flint/jobs/[^""]+)"">(?<Title>[^<]+)</a></div><div class=""job-details""><div class=""job-detail"">(?<Location>[^<]+)</div><div class=""job-detail"">(?<Equity>[^<]+)</div><div class=""job-detail"">(?<Experience>[^<]+)" >

    let jobs =
        Http.RequestString("https://www.ycombinator.com/companies/flint")
        |> JobRegex().TypedMatches
        |> Seq.map (fun m ->
            ({ Url = m.Url.Value
               Title = m.Title.Value
               Location = m.Location.Value
               Equity = m.Equity.Value
               Experience = m.Experience.Value }))
        |> Seq.sortBy (fun job -> job.Title)
        |> json

    type Article =
        { Author: String
          Bio: String
          Link: String
          Avatar: String
          Slug: String
          Date: String
          Title: String
          Sub: String
          Body: String }

    let root =
        Directory.GetParent(Directory.GetCurrentDirectory())

    let lines path =
        seq { yield! System.IO.File.ReadLines path }
        |> Seq.toList

    let parseArticle =
        function
        | (author :: bio :: link :: avatar :: _ :: slug :: date :: title :: sub :: _ :: body) ->
            Some
                { Author = author
                  Bio = bio
                  Link = link
                  Avatar = avatar
                  Slug = slug
                  Date = date
                  Title = title
                  Sub = sub
                  Body = String.concat "\n" <| body }
        | _ -> None

    let articles =
        Directory.GetFiles($"{root}/blog/", "*.md")
        |> Seq.sortDescending
        |> Seq.toList
        |> List.map (lines >> parseArticle)
        |> List.choose id
        |> json

    let healthz () =
        let env =
            Environment.GetEnvironmentVariable("ENV")

        let gv =
            Environment.GetEnvironmentVariable("GIT_VERSION")

        let now = DateTime.Now.ToUniversalTime()

        $"Ok,{env},{gv},{now}"

    let blogs =
        fun (next: HttpFunc) (ctx: HttpContext) -> task { return! articles next ctx }

    let yc =
        fun (next: HttpFunc) (ctx: HttpContext) -> task { return! jobs next ctx }

    let apply =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let form key = ctx.Request.Form.Item(key).ToString()

                let formData =
                    {| applicationTitle = form ("applicationTitle")
                       firstName = form "firstName"
                       lastName = form "lastName"
                       email = form "email"
                       phone = form "phone"
                       reason = form "reason" |}

                printfn "Application received %A" formData

                let attachments =
                    (match ctx.Request.HasFormContentType with
                     | false -> []
                     | true ->
                         ctx.Request.Form.Files
                         |> Seq.fold
                             (fun acc file ->

                                 let target = MemoryStream()

                                 file.CopyToAsync(target, CancellationToken(false))
                                 |> Async.AwaitTask
                                 |> Async.RunSynchronously

                                 target.Position <- 0L

                                 acc
                                 @ [ (target, file.ContentType, file.FileName) ])
                             [])

                let body =
                    $"""{formData.reason}<br><br>{formData.firstName} {formData.lastName}<br>{formData.phone}<br>{formData.email}"""

                use smtpClient = SmtpClient("smtp-relay.gmail.com", 587)

                smtpClient.EnableSsl <- true

                use jobs =
                    MailMessage("jobs+ws@withflint.com", "jobs+ws@withflint.com")

                attachments
                |> List.iter (fun (contents, contentType, fileName) ->
                    jobs.Attachments.Add(Attachment(contents, fileName, contentType)))

                jobs.Subject <-
                    $"Flint - New Application : {formData.firstName} {formData.lastName}, {formData.applicationTitle}"

                jobs.Body <- body
                jobs.IsBodyHtml <- true
                jobs.ReplyToList.Add(formData.email)

                smtpClient.Send(jobs)

                attachments
                |> List.iter (fun (stream, _, _) -> stream.Dispose())

                use candidate =
                    MailMessage("simon@withflint.com", formData.email)

                candidate.Subject <- "Thank you for applying"
                candidate.IsBodyHtml <- true

                candidate.Body <-
                    $"""Hello {formData.firstName},<br><br>Thank you for your interest in the {formData.applicationTitle} position at Flint.<br>I will review your candidacy and get back to you shortly.<br><br>Kind Regards,<br><br>Simon Green<br>Head of Engineering at <a href='https://withflint.com/'> Flint </a>"""

                smtpClient.Send(candidate)

                return! json {| success = "OK" |} next ctx
            }

    let webApp: HttpHandler =
        choose [ GET
                 >=> choose [ route "/" >=> htmlFile "../index.html"
                              route "/yc" >=> yc
                              route "/careers" >=> redirectTo true "/jobs"
                              subRoute
                                  "/blog"
                                  (choose [ route "" >=> htmlFile "../index.html"
                                            routef "/%s" (fun _ -> htmlFile "../index.html") ])
                              route "/articles" >=> blogs
                              route "/healthz" >=> text (healthz ()) ]
                 POST >=> choose [ route "/apply" >=> apply ]
                 setStatusCode 200 >=> htmlFile "../index.html" ]

    let configureApp (app: IApplicationBuilder) =
        let path =
            Path.Combine(Directory.GetCurrentDirectory(), @"../static")

        use provider = PhysicalFileProvider(path)

        app
            .UseRewriter(
                (RewriteOptions())
                    .AddRewrite("favicon.ico", "static/favicon.ico", false)
            )
            .UseDefaultFiles()
            .UseStaticFiles(StaticFileOptions(FileProvider = provider, RequestPath = PathString("/static")))
            .UseGiraffe(webApp)

    let configureServices (services: IServiceCollection) = services.AddGiraffe() |> ignore

    [<EntryPoint>]
    let main _ =

        Host
            .CreateDefaultBuilder()
            .ConfigureWebHostDefaults(fun webHostBuilder ->
                webHostBuilder
                    .UseUrls("http://+:5000")
                    .Configure(configureApp)
                    .ConfigureServices(configureServices)
                |> ignore)
            .Build()
            .Run()

        printfn "Exiting"

        0
