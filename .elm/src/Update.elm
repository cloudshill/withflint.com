module Update exposing (init, update)

import Browser.Navigation exposing (Key)
import Contact.Update
import FAQ.Update
import Home.Update
import Return exposing (Return, andMap, mapCmd, singleton)
import Router.Update
import Types exposing (..)
import Url exposing (Url)


init : () -> Url -> Key -> Return Msg Model
init _ url key =
    singleton Model
        |> andMapCmd MsgForRouter (Router.Update.init url key)
        |> andMapCmd MsgForContact Contact.Update.init
        |> andMapCmd MsgForFAQ FAQ.Update.init
        |> andMapCmd MsgForHome Home.Update.init


update : Msg -> Model -> Return Msg Model
update msg model =
    singleton Model
        |> andMapCmd MsgForRouter (Router.Update.update msg model.router)
        |> andMapCmd MsgForContact (Contact.Update.update msg model.contact)
        |> andMapCmd MsgForFAQ (FAQ.Update.update msg model.faq)
        |> andMapCmd MsgForHome (Home.Update.update msg model.home)


andMapCmd : (msg1 -> msg2) -> Return msg1 model1 -> Return msg2 (model1 -> model2) -> Return msg2 model2
andMapCmd msg =
    andMap << mapCmd msg
