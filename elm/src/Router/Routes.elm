module Router.Routes exposing (Page(..), routes, toPath)

import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Page
    = Home
    | NotFound
    | Contact
    | FAQ
    | Jobs
    | Blog String


routes : Parser (Page -> a) a
routes =
    oneOf
        [ map Home top
        , map NotFound (s "404")
        , map Contact (s "contact")
        , map FAQ (s "faq")
        , map Jobs (s "jobs")
        , map (Blog "") (s "blog")
        , map Blog (s "blog" </> string)
        ]


toPath : Page -> String
toPath page =
    case page of
        Home ->
            "/"

        NotFound ->
            "/404"

        Contact ->
            "/contact"

        FAQ ->
            "/faq"

        Jobs ->
            "/jobs"

        Blog path ->
            "/blog/" ++ path
