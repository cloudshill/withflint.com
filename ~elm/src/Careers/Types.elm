module Careers.Types exposing (Job, JobsStatus(..), Model, Msg(..))

import Browser.Dom exposing (Viewport)
import Element exposing (Device)
import Http


type alias Model =
    { jobs : JobsStatus
    , device : Device
    , gitVersion : String
    }


type Msg
    = SetScreenSize Int Int
    | LoadPage Viewport
    | ReceiveYCJobsData (Result Http.Error String)


type JobsStatus
    = Loading
    | Results (List Job)
    | NoJobs


type alias Job =
    { url : String
    , title : String
    , location : String
    , equity : String
    , experience : String
    }
