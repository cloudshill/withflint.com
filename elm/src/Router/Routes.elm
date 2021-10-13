module Router.Routes exposing (Page(..), routes, toPath)

import Url.Parser exposing (Parser, map, oneOf, s, top)


type Page
    = Home
    | NotFound
    | Contact
    | FAQ


routes : Parser (Page -> a) a
routes =
    oneOf
        [ map Home top
        , map NotFound (s "404")
        , map Contact (s "contact")
        , map FAQ (s "faq")
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
