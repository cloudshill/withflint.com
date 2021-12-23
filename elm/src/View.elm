module View exposing (view)

import Blog.Update exposing (loadArticle)
import Blog.View
import Contact.View
import Element
    exposing
        ( Element
        , el
        , fill
        , height
        , text
        , width
        )
import FAQ.View
import Home.View
import Html exposing (Html)
import Jobs.View
import Router.Routes exposing (Page(..))
import Styles
import Types exposing (Model, Msg(..))


view : Model -> { title : String, body : List (Html Types.Msg) }
view model =
    { title = "Flint — Competitive Prices without the hassle"
    , body = [ Element.layout [ Styles.font, width fill, height fill ] <| el [ width fill, height fill ] (renderRoute model) ]
    }


renderRoute : Types.Model -> Element Types.Msg
renderRoute model =
    case model.router.page of
        Home ->
            Element.map MsgForHome (Home.View.view model.home)

        NotFound ->
            text "404 Not Found"

        Contact ->
            Element.map MsgForContact (Contact.View.view model.contact)

        FAQ ->
            Element.map MsgForFAQ (FAQ.View.view model.faq)

        Jobs ->
            Element.map MsgForJobs (Jobs.View.view model.jobs)

        Blog viewing ->
            Element.map MsgForBlog
                (Blog.View.view
                    (loadArticle model.blog viewing)
                )
