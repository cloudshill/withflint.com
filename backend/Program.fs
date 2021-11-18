namespace withflint.com.backend

module Program =
    open System
    open System.IO
    open System.Net.Mail

    open Microsoft.AspNetCore.Builder
    open Microsoft.AspNetCore.Hosting
    open Microsoft.Extensions.Hosting
    open Microsoft.Extensions.DependencyInjection
    open Microsoft.AspNetCore.Http
    open Microsoft.Extensions.FileProviders
    open Microsoft.AspNetCore.Rewrite

    open System.Threading

    open Giraffe
    open FSharp.Data
    open FSharp.Control.Tasks.Affine
    open System.Collections.Generic

    open Memoization

    let healthz () =
        let env =
            Environment.GetEnvironmentVariable("ENV")

        let gv =
            Environment.GetEnvironmentVariable("GIT_VERSION")

        let now = DateTime.Now.ToUniversalTime()

        $"Ok,{env},{gv},{now}"

    let get = memoization Http.RequestString

    let yc =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let res =
                    get ("https://www.ycombinator.com/companies/flint")

                return! text res next ctx
            }

    let apply =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let attachments =
                    (match ctx.Request.HasFormContentType with
                     | false -> []
                     | true ->
                         ctx.Request.Form.Files
                         |> Seq.fold
                             (fun acc file ->

                                 let target = new MemoryStream()

                                 file.CopyToAsync(target, CancellationToken(false))
                                 |> Async.AwaitTask
                                 |> Async.RunSynchronously

                                 target.Position <- 0L


                                 acc @ [ (target, file.ContentType) ])
                             [])

                let formData =
                    {| applicationTitle =
                           ctx
                               .Request
                               .Form
                               .Item("applicationTitle")
                               .ToString()
                       firstName = ctx.Request.Form.Item("firstName").ToString()
                       lastName = ctx.Request.Form.Item("lastName").ToString()
                       email = ctx.Request.Form.Item("email").ToString()
                       phone = ctx.Request.Form.Item("phone").ToString()
                       reason = ctx.Request.Form.Item("reason").ToString() |}



                let body =
                    $"""
                {formData.reason}
                <br><br>
                {formData.firstName} {formData.lastName}
                <br>
                {formData.phone}
                <br>
                {formData.email}
                """

                use smtpClient =
                    new SmtpClient("smtp-relay.gmail.com", 587)

                smtpClient.EnableSsl <- true

                use mailToManager =
                    new MailMessage("careers@withflint.com", "simon@withflint.com")

                attachments
                |> List.map
                    (fun (contents, contentType) ->
                        mailToManager.Attachments.Add(new Attachment(contents, "", contentType)))
                |> ignore

                mailToManager.Subject <-
                    "Flint - New Application : "
                    + formData.firstName
                    + " "
                    + formData.lastName
                    + " "
                    + formData.applicationTitle

                mailToManager.Body <- body
                mailToManager.IsBodyHtml <- true

                mailToManager.ReplyToList.Add(formData.email)

                smtpClient.Send(mailToManager)

                attachments
                |> List.map (fun (stream, _) -> stream.Dispose())
                |> ignore


                use mailToApplicant =
                    new MailMessage("simon@withflint.com", ctx.Request.Form.Item("email").ToString())

                mailToApplicant.Subject <- "Thank you for applying"
                mailToApplicant.IsBodyHtml <- true

                mailToApplicant.Body <-
                    $"""Hello {formData.firstName},
                <br><br>
                Thank you for your interest in the {formData.applicationTitle} position at Flint.
                <br>
                I will review your candidacy and get back to you shortly.
                <br><br>
                Kind Regards,
                <br><br>
                Simon Green
                <br>
                Head of Engineering at <a href='https://withflint.com/'> Flint </a>"""

                smtpClient.Send(mailToApplicant)

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

        use provider =  PhysicalFileProvider(path)
        provider

    let configureApp (app: IApplicationBuilder) =
        let fileProvider = getDirectory ()

        app
            .UseRewriter((RewriteOptions()).AddRewrite("favicon.ico", "static/favicon.ico", false))
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
