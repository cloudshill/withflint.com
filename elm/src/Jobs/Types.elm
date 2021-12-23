module Jobs.Types exposing (Applicant, ApplicationStatus(..), Field(..), Job, JobsStatus(..), Model, Msg(..), SubmissionMessage(..))

import Browser.Dom exposing (Viewport)
import Device exposing (Device)
import File exposing (File)
import Http


type alias Model =
    { jobs : JobsStatus
    , device : Device
    , gitVersion : String
    , applicant : Applicant
    , error : String
    , submissionMessage : SubmissionMessage
    , applicationTitle : String
    , phoneView : Bool
    , applicationStatus : ApplicationStatus
    }


type Msg
    = SetScreenSize Int Int
    | LoadPage Viewport
    | ReceiveYCJobsData (Result Http.Error String)
    | SendApplicantData (Result Http.Error String)
    | Update Model
    | UpdateAndScrollToTop Model
    | UploadResume
    | Resume File
    | Submit
    | NoOp


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


type alias Applicant =
    { firstName : Field String
    , lastName : Field String
    , email : Field String
    , phone : Field String
    , resume : Field (Maybe File)
    , reason : Field String
    }


type ApplicationStatus
    = NewSubmission
    | Uploading
    | Submitted
    | NotInitialized


type SubmissionMessage
    = OK
    | Error


type Field fieldType
    = Empty
    | Valid fieldType
    | Invalid
