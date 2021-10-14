module Home.Types exposing (Model, Msg(..))

import Browser.Dom exposing (Viewport)
import Element exposing (Device)


type alias Model =
    { topic : String
    , device : Device
    }


type Msg
    = SetScreenSize Int Int
    | GotViewport Viewport
