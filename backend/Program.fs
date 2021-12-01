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

    open Memoization

    type Job =
        { Url: String
          Title: String
          Location: String
          Equity: String
          Experience: String }

    type JobRegex =
        Regex< @"(?<Url>https://www.ycombinator.com/companies/flint/jobs/[^""]+)"">(?<Title>[^<]+)</a></div><div class=""job-details""><div class=""job-detail"">(?<Location>[^<]+)</div><div class=""job-detail"">(?<Equity>[^<]+)</div><div class=""job-detail"">(?<Experience>[^<]+)" >

    let jobs =
        memoize (fun (url) ->
            Http.RequestString(url)
            |> JobRegex().TypedMatches
            |> Seq.map (fun m ->
                ({ Url = m.Url.Value
                   Title = m.Title.Value
                   Location = m.Location.Value
                   Equity = m.Equity.Value
                   Experience = m.Experience.Value }))
            |> Seq.sortBy (fun job -> job.Title)
            |> json)

    let healthz () =
        let env =
            Environment.GetEnvironmentVariable("ENV")

        let gv =
            Environment.GetEnvironmentVariable("GIT_VERSION")

        let now = DateTime.Now.ToUniversalTime()

        $"Ok,{env},{gv},{now}"

    let yc =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task { return! (jobs ("https://www.ycombinator.com/companies/flint")) next ctx }

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

                use careers =
                    MailMessage("careers+ws@withflint.com", "careers+ws@withflint.com")

                attachments
                |> List.iter (fun (contents, contentType, fileName) ->
                    careers.Attachments.Add(Attachment(contents, fileName, contentType)))

                careers.Subject <-
                    $"Flint - New Application : {formData.firstName} {formData.lastName}, {formData.applicationTitle}"

                careers.Body <- body
                careers.IsBodyHtml <- true
                careers.ReplyToList.Add(formData.email)

                smtpClient.Send(careers)

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
                              route "/healthz" >=> text (healthz ()) ]
                 POST >=> choose [ route "/apply" >=> apply ]
                 setStatusCode 200 >=> htmlFile "../index.html" ]

    let getDirectory () =
        let path =
            Path.Combine(Directory.GetCurrentDirectory(), @"../static")

        use provider = PhysicalFileProvider(path)
        provider

    let configureApp (app: IApplicationBuilder) =
        let fileProvider = getDirectory ()

        app
            .UseRewriter(
                (RewriteOptions())
                    .AddRewrite("favicon.ico", "static/favicon.ico", false)
            )
            .UseDefaultFiles()
            .UseStaticFiles(StaticFileOptions(FileProvider = fileProvider, RequestPath = PathString("/static")))
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
