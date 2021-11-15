module Router.Update exposing (init, update)

import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Navigation exposing (Key, load, pushUrl)
import Return exposing (Return, return)
import Router.Routes exposing (Page(..), routes)
import Router.Types exposing (Model, Msg(..))
import Task
import Types
import Url exposing (Url)
import Url.Parser exposing (parse)


init : Url -> Key -> Return Msg Model
init url key =
    return
        { page = Maybe.withDefault NotFound <| parse routes url
        , key = key
        }
        Cmd.none


update : Types.Msg -> Model -> Return Msg Model
update msgFor model =
    case msgFor of
        Types.MsgForRouter msg ->
            updateRouter msg model

        _ ->
            return model Cmd.none


updateRouter : Msg -> Model -> Return Msg Model
updateRouter msg model =
    case msg of
        OnUrlChange url ->
            return { model | page = Maybe.withDefault NotFound <| parse routes url }
                (Task.perform (\_ -> NoOp) (Browser.Dom.setViewport 0 0))

        OnUrlRequest urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, pushUrl model.key <| Url.toString url )

                External url ->
                    ( model, load url )

        NoOp ->
            return model Cmd.none
