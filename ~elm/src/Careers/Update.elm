module Careers.Update exposing (init, update)

import Browser.Dom
import Careers.Types exposing (Job, JobsStatus(..), Model, Msg(..))
import Element exposing (Device, DeviceClass(..), Orientation(..))
import Http
import Maybe exposing (withDefault)
import Regex
import Return exposing (Return, return)
import Task
import Types


findJobs : Regex.Regex
findJobs =
    Maybe.withDefault Regex.never <|
        Regex.fromString """(https:\\/\\/www\\.ycombinator\\.com\\/companies\\/flint\\/jobs\\/[^"]+)">([^<]+)<\\/a><\\/div><div class="job-details"><div class="job-detail">([^<]+)<\\/div><div class="job-detail">([^<]+)<\\/div><div class="job-detail">([^<]+)"""


defaulToEmptyString : Maybe String -> String
defaulToEmptyString =
    withDefault ""


parseJobs : List (Maybe String) -> Job
parseJobs list =
    case list of
        [ url, title, location, equity, experience ] ->
            { url = url |> defaulToEmptyString
            , title = title |> defaulToEmptyString
            , location = location |> defaulToEmptyString
            , equity = equity |> defaulToEmptyString
            , experience = experience |> defaulToEmptyString
            }

        _ ->
            { url = ""
            , title = ""
            , location = ""
            , equity = ""
            , experience = ""
            }


init : String -> Return Msg Model
init gitVersion =
    return
        { jobs = Loading
        , gitVersion = gitVersion
        , device =
            classifyDevice
                { height = 0
                , width = 0
                }
        }
        (Task.perform LoadPage Browser.Dom.getViewport)


update : Types.Msg -> Model -> Return Msg Model
update msgFor model =
    case msgFor of
        Types.MsgForCareers msg ->
            updateCareers msg model

        _ ->
            return model Cmd.none


updateCareers : Msg -> Model -> Return Msg Model
updateCareers msg model =
    case msg of
        LoadPage viewport ->
            return
                { model
                    | device =
                        classifyDevice
                            { width = round viewport.viewport.width
                            , height = round viewport.viewport.height
                            }
                }
                (Http.get
                    { url = "/static/" ++ model.gitVersion ++ "/yc.html"
                    , expect = Http.expectString ReceiveYCJobsData
                    }
                )

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

        ReceiveYCJobsData result ->
            case result of
                Ok html ->
                    return { model | jobs = Regex.find findJobs html |> List.map (.submatches >> parseJobs) |> Results } Cmd.none

                Err _ ->
                    return { model | jobs = NoJobs } Cmd.none


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

        else if longSide <= 1200 then
            Tablet

        else if longSide > 1200 && longSide <= 1920 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }
