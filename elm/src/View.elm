module View exposing (view)

import Careers.View
import Contact.View
import Element
    exposing
        ( Element
        , centerX
        , el
        , fill
        , height
        , maximum
        , paddingXY
        , scrollbarY
        , text
        , width
        )
import FAQ.View
import Home.View
import Html exposing (Html)
import Router.Routes exposing (Page(..))
import Types exposing (Model, Msg(..))


view : Model -> { title : String, body : List (Html Types.Msg) }
view model =
    { title = "Flint — Competitive Prices without the hassle"
    , body = [ Element.layout [ width fill, height fill, scrollbarY ] <| el [ paddingXY 0 40, width <| maximum 1500 fill, centerX, height fill ] (renderRoute model) ]
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

        Careers ->
            Element.map MsgForCareers (Careers.View.view model.careers)
