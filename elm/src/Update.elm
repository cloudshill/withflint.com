module Update exposing (init, update)

import Blog.Update
import Browser.Navigation exposing (Key)
import Contact.Update
import FAQ.Update
import Home.Update
import Jobs.Update
import Return exposing (Return, andMap, mapCmd, singleton)
import Router.Update
import Types exposing (Model, Msg(..))
import Url exposing (Url)


init : { article : Maybe String, gitVersion : String } -> (Url -> (Key -> Return Msg Model))
init { article, gitVersion } url key =
    singleton Model
        |> andMapCmd MsgForRouter (Router.Update.init url key)
        |> andMapCmd MsgForContact Contact.Update.init
        |> andMapCmd MsgForFAQ FAQ.Update.init
        |> andMapCmd MsgForHome Home.Update.init
        |> andMapCmd MsgForJobs (Jobs.Update.init gitVersion)
        |> andMapCmd MsgForBlog (Blog.Update.init article)


update : Msg -> (Model -> Return Msg Model)
update msg model =
    singleton Model
        |> andMapCmd MsgForRouter (Router.Update.update msg model.router)
        |> andMapCmd MsgForContact (Contact.Update.update msg model.contact)
        |> andMapCmd MsgForFAQ (FAQ.Update.update msg model.faq)
        |> andMapCmd MsgForHome (Home.Update.update msg model.home)
        |> andMapCmd MsgForJobs (Jobs.Update.update msg model.jobs)
        |> andMapCmd MsgForBlog (Blog.Update.update msg model.blog)


andMapCmd : (msg1 -> msg2) -> (Return msg1 model1 -> (Return msg2 (model1 -> model2) -> Return msg2 model2))
andMapCmd msg =
    andMap << mapCmd msg
