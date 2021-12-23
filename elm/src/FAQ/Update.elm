module FAQ.Update exposing (init, update)

import Browser.Dom
import Device exposing (Device(..), classify)
import FAQ.Types exposing (Model, Msg(..))
import Return exposing (Return, return)
import Task
import Types


init : Return Msg Model
init =
    return
        { topic = ""
        , device = NotSet
        }
        (Task.perform GotViewport Browser.Dom.getViewport)


update : Types.Msg -> Model -> Return Msg Model
update msgFor model =
    case msgFor of
        Types.MsgForFAQ msg ->
            updateFAQ msg model

        _ ->
            return model Cmd.none


updateFAQ : Msg -> Model -> Return Msg Model
updateFAQ msg model =
    case msg of
        GotViewport viewport ->
            return
                { model
                    | device =
                        classify
                            { width = round viewport.viewport.width
                            , height = round viewport.viewport.height
                            }
                }
                Cmd.none

        SetScreenSize x y ->
            return
                { model
                    | device =
                        classify
                            { width = x
                            , height = y
                            }
                }
                Cmd.none
