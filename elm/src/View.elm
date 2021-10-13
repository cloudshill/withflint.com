module View exposing (view)

import Contact.View
import Element exposing (..)
import FAQ.View
import Home.View
import Html exposing (Html)
import Router.Routes exposing (..)
import Types exposing (..)


view : Model -> { title : String, body : List (Html Types.Msg) }
view model =
    { title = "Flint — Competitive Prices without the hassle"
    , body =
        [ Element.layout [ width fill ] <|
            el [ paddingXY 0 40, width fill ] (renderRoute model)
        ]
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
