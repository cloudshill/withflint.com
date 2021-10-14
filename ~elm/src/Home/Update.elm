module Home.Update exposing (init, update)

import Browser.Dom
import Element exposing (Device, DeviceClass(..), Orientation(..))
import Home.Types exposing (Model, Msg(..))
import Return exposing (Return, return)
import Task
import Types


init : Return Msg Model
init =
    return
        { topic = ""
        , device =
            classifyDevice
                { height = 0
                , width = 0
                }
        }
        (Task.perform GotViewport Browser.Dom.getViewport)


update : Types.Msg -> Model -> Return Msg Model
update msgFor model =
    case msgFor of
        Types.MsgForHome msg ->
            updateHome msg model

        _ ->
            return model Cmd.none


updateHome : Msg -> Model -> Return Msg Model
updateHome msg model =
    case msg of
        GotViewport viewport ->
            return
                { model
                    | device =
                        classifyDevice
                            { width = round viewport.viewport.width
                            , height = round viewport.viewport.height
                            }
                }
                Cmd.none

        SetScreenSize x y ->
            return
                { model
                    | device =
                        classifyDevice
                            { width = x
                            , height = y
                            }
                }
                Cmd.none


classifyDevice : { window | height : Int, width : Int } -> Device
classifyDevice window =
    { class =
        let
            longSide : Int
            longSide =
                max window.width window.height

            shortSide : Int
            shortSide =
                min window.width window.height
        in
        if shortSide < 700 then
            Phone

        else if longSide <= 1300 then
            Tablet

        else if longSide > 1300 && longSide <= 1920 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }
