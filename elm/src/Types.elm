module Types exposing (Model, Msg(..))

import Contact.Types
import FAQ.Types
import Home.Types
import Router.Types


type alias Model =
    { router : Router.Types.Model
    , contact : Contact.Types.Model
    , faq : FAQ.Types.Model
    , home : Home.Types.Model
    }


type Msg
    = MsgForRouter Router.Types.Msg
    | MsgForContact Contact.Types.Msg
    | MsgForFAQ FAQ.Types.Msg
    | MsgForHome Home.Types.Msg
