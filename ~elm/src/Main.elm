module Main exposing (main)

import Browser
import Browser.Events as Events
import Careers.Types
import Contact.Types
import FAQ.Types
import Home.Types
import Router.Types
import Types exposing (Msg(..))
import Update exposing (init, update)
import View exposing (view)


main : Program String Types.Model Types.Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = MsgForRouter << Router.Types.OnUrlChange
        , onUrlRequest = MsgForRouter << Router.Types.OnUrlRequest
        }


subscriptions : Types.Model -> Sub Types.Msg
subscriptions _ =
    Sub.batch
        [ Events.onResize (\x y -> MsgForContact (Contact.Types.SetScreenSize x y))
        , Events.onResize (\x y -> MsgForHome (Home.Types.SetScreenSize x y))
        , Events.onResize (\x y -> MsgForFAQ (FAQ.Types.SetScreenSize x y))
        , Events.onResize (\x y -> MsgForCareers (Careers.Types.SetScreenSize x y))
        ]
