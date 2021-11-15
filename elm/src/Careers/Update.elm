module Careers.Update exposing (init, update)

import Browser.Dom
import Careers.Types exposing (ApplicationStatus(..), Field(..), Job, JobsStatus(..), Model, Msg(..), SubmissionMessage(..))
import Device exposing (classify)
import File.Select as Select
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
            classify
                { height = 0
                , width = 0
                }
        , applicant =
            { firstName = Empty
            , lastName = Empty
            , email = Empty
            , phone = Empty
            , resume = Empty
            , reason = Empty
            }
        , error = "\n"
        , submissionMessage = OK
        , applicationTitle = ""
        , phoneView = True
        , applicationStatus = NotInitialized
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
                        classify
                            { width = round viewport.viewport.width
                            , height = round viewport.viewport.height
                            }
                }
                (Http.get
                    { url = "/yc"
                    , expect = Http.expectString ReceiveYCJobsData
                    }
                )

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

        ReceiveYCJobsData result ->
            case result of
                Ok html ->
                    return { model | jobs = Regex.find findJobs html |> List.map (.submatches >> parseJobs) |> Results } Cmd.none

                Err _ ->
                    return { model | jobs = NoJobs } Cmd.none

        Update model_ ->
            return model_ Cmd.none

        LoadCurrentPage model_ ->
            return model_ (Task.perform (\_ -> Update model_) (Browser.Dom.setViewport 0 0))

        UploadResume ->
            return model (Select.file [ "docx", "pdf", "doc", "*" ] Resume)

        Resume file ->
            let
                applicant : Careers.Types.Applicant
                applicant =
                    model.applicant
            in
            ( { model
                | applicant = { applicant | resume = Valid (Just file) }
              }
            , Cmd.none
            )

        Submit ->
            let
                valid : Bool
                valid =
                    List.all
                        (\field ->
                            case field of
                                Valid _ ->
                                    True

                                _ ->
                                    False
                        )
                        [ model.applicant.firstName, model.applicant.lastName, model.applicant.email, model.applicant.phone, model.applicant.reason ]

                applicant : Careers.Types.Applicant
                applicant =
                    model.applicant
            in
            if valid then
                return
                    { model | applicationStatus = Uploading, error = "" }
                    (Maybe.map
                        (\file ->
                            Http.post
                                { url = "/apply"
                                , body =
                                    Http.multipartBody <|
                                        [ Http.stringPart "applicationTitle" model.applicationTitle
                                        , Http.stringPart "firstName" (value "" model.applicant.firstName)
                                        , Http.stringPart "lastName" (value "" model.applicant.lastName)
                                        , Http.stringPart "email" (value "" model.applicant.email)
                                        , Http.stringPart "phone" (value "" model.applicant.phone)
                                        , Http.stringPart "reason" (value "" model.applicant.reason)
                                        , Http.filePart "resume" file
                                        ]
                                , expect = Http.expectString SendApplicantData
                                }
                        )
                        (value Nothing model.applicant.resume)
                        |> Maybe.withDefault Cmd.none
                    )

            else
                return
                    { model
                        | error = "Please fill all the required fields"
                        , applicant =
                            { applicant
                                | firstName = invalidIfEmpty model.applicant.firstName
                                , lastName = invalidIfEmpty model.applicant.lastName
                                , phone = invalidIfEmpty model.applicant.phone
                                , email = invalidIfEmpty model.applicant.email
                                , reason = invalidIfEmpty model.applicant.reason
                                , resume = invalidIfEmpty model.applicant.resume
                            }
                    }
                    Cmd.none

        SendApplicantData result ->
            case result of
                Ok _ ->
                    return
                        { model
                            | applicationStatus = Submitted
                            , submissionMessage = OK
                        }
                        (Http.get
                            { url = "/yc"
                            , expect = Http.expectString ReceiveYCJobsData
                            }
                        )

                Err _ ->
                    return
                        { model
                            | applicationStatus = Submitted
                            , submissionMessage = Error
                        }
                        (Http.get
                            { url = "/yc"
                            , expect = Http.expectString ReceiveYCJobsData
                            }
                        )


value : a -> Field a -> a
value default field =
    case field of
        Valid fieldType ->
            fieldType

        _ ->
            default


invalidIfEmpty : Field fieldType -> Field fieldType
invalidIfEmpty field =
    case field of
        Empty ->
            Invalid

        _ ->
            field
