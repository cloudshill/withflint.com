module Contact.Update exposing (init, update)

import Browser.Dom
import Contact.Types exposing (Model, Msg(..))
import Device exposing (Device(..), classify)
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
        Types.MsgForContact msg ->
            updateContact msg model

        _ ->
            return model Cmd.none


updateContact : Msg -> Model -> Return Msg Model
updateContact msg model =
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
