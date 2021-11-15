module Careers.View exposing (view)

import Careers.Types exposing (ApplicationStatus(..), Field(..), Job, JobsStatus(..), Model, Msg(..), SubmissionMessage(..))
import Element
    exposing
        ( DeviceClass(..)
        , Element
        , alignLeft
        , alignRight
        , alignTop
        , centerX
        , centerY
        , column
        , fill
        , focused
        , height
        , image
        , inFront
        , maximum
        , minimum
        , mouseOver
        , newTabLink
        , padding
        , paddingEach
        , paddingXY
        , paragraph
        , px
        , row
        , scrollbarY
        , shrink
        , spacing
        , spacingXY
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import File
import Layout exposing (footer, header, layout)
import List
import Regex
import Styles exposing (buttons, colors, form, heading)


view : Model -> Element Msg
view model =
    column [ height fill, width fill ] (layout { phone = phoneLayout, tablet = tabletLayout, desktop = desktopLayout } model.device.class model)


phoneView : DeviceClass -> Job -> Model -> Element Msg
phoneView _ job model =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10, width fill, paddingXY 10 0 ]
            [ row [ Font.color colors.orange1, width <| maximum 300 fill ]
                [ paragraph []
                    [ newTabLink [ mouseOver [ Font.color colors.orange2 ] ]
                        { url = job.url
                        , label = text job.title
                        }
                    ]
                ]
            , row [ Font.size 15, width fill ]
                [ column [ spacingXY 0 10 ]
                    [ row [ alignLeft ] [ text job.location ]
                    , row [ alignLeft ] [ text job.equity ]
                    , row [ alignLeft ] [ text job.experience ]
                    ]
                ]
            ]
        , column
            [ alignTop
            , alignRight
            ]
            [ Input.button
                [ Border.color colors.orange1
                , Border.width 1
                , Border.rounded 2
                , padding 10
                , Font.size 15
                , Font.color colors.white3
                , Background.color colors.orange1
                , mouseOver [ Background.color colors.orange2 ]
                ]
                { onPress = Just (LoadCurrentPage { model | applicationStatus = NewSubmission, phoneView = False, applicationTitle = job.title })
                , label = text "Apply Now"
                }
            ]
        ]


phoneLayout : DeviceClass -> Model -> List (Element Msg)
phoneLayout device model =
    [ column
        [ width fill
        , paddingXY 30 0
        , spacingXY 0 20
        ]
        [ row [ width fill ] (header device)
        , row [ width fill, height fill, paddingXY 0 50 ]
            [ column [ centerX, width fill ]
                [ row
                    (heading ++ [ centerX ])
                    [ text "Careers" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 60, width <| maximum 500 fill, centerX ]
            (if model.phoneView then
                case model.jobs of
                    Results jobs ->
                        jobs
                            |> List.map
                                (\job ->
                                    row [ centerX, width fill ]
                                        [ phoneView device job model
                                        ]
                                )

                    Loading ->
                        [ row [] [ text "Loading ..." ] ]

                    NoJobs ->
                        [ row [] [ text "No Jobs" ] ]

             else
                [ applicationForm device model ]
            )
        , column [ width fill ] (footer device)
        ]
    ]


tabletLayout : DeviceClass -> Model -> List (Element Msg)
tabletLayout device model =
    [ column
        [ width fill
        , paddingXY 50 0
        , inFront <| applicationForm device model
        ]
        [ row [ width fill ] (header device)
        , row [ width fill, height fill, paddingXY 0 50 ]
            [ column [ centerX, width fill, width (minimum 600 shrink) ]
                [ row
                    (heading ++ [ centerX ])
                    [ text "Careers" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 40, centerX ]
            (case model.jobs of
                Results jobs ->
                    jobs
                        |> List.map
                            (\job -> column [ width fill, centerX ] [ jobView job model ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill ] (footer device)
        ]
    ]


jobView : { a | title : String, location : String, equity : String, experience : String, url : String } -> Model -> Element Msg
jobView job model =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10 ]
            [ row [ Font.color colors.orange1 ]
                [ newTabLink [ mouseOver [ Font.color colors.orange2 ] ]
                    { url = job.url
                    , label = text job.title
                    }
                ]
            , row [ Font.size 15, spacingXY 30 0 ]
                [ column [] [ text job.location ]
                , column [] [ text job.equity ]
                , column [] [ text job.experience ]
                ]
            ]
        , column
            [ alignRight
            ]
            [ Input.button
                [ Border.color colors.orange1
                , Border.width 1
                , Border.rounded 2
                , padding 10
                , Font.size 15
                , Font.color colors.white3
                , Background.color colors.orange1
                , mouseOver [ Background.color colors.orange2 ]
                ]
                { onPress = Just (Update { model | applicationStatus = NewSubmission, applicationTitle = job.title })
                , label = text "Apply Now"
                }
            ]
        ]


desktopLayout : DeviceClass -> Model -> List (Element Msg)
desktopLayout device model =
    [ column
        [ width fill
        , paddingXY 100 0
        , centerX
        , inFront <| applicationForm device model
        ]
        [ row [ width fill ] (header device)
        , row [ width fill, height fill, paddingEach { left = 0, right = 0, top = 100, bottom = 50 }, spacing 10 ]
            [ column [ width fill, width (minimum 600 shrink), width fill, centerX ]
                [ paragraph
                    heading
                    [ text "Careers" ]
                ]
            ]
        , column [ width fill, height fill, centerX, spacingXY 20 40, paddingEach { top = 5, bottom = 40, left = 0, right = 0 } ]
            (case model.jobs of
                Results jobs ->
                    jobs
                        |> List.map
                            (\job -> column [ width fill, centerX ] [ jobView job model ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill ] (footer device)
        ]
    ]


applicationForm : DeviceClass -> Model -> Element Msg
applicationForm device model =
    case model.applicationStatus of
        NewSubmission ->
            newSubmissionForm device model

        Uploading ->
            form device
                [ column [ width fill, spacingXY 0 20 ]
                    [ row [ width fill ]
                        (case device of
                            Phone ->
                                [ text "" ]

                            _ ->
                                [ column [ Font.size 20 ] [ text "Uploading" ]
                                , column [ alignRight ]
                                    [ Input.button [ paddingEach { top = 0, bottom = 3, left = 5, right = 5 }, Border.rounded 2, Font.size 15, Font.color colors.red4, mouseOver [ Font.color colors.white3, Background.color colors.red4 ] ]
                                        { onPress =
                                            Just
                                                (Update
                                                    { model
                                                        | applicationStatus = NotInitialized
                                                        , error = ""
                                                        , applicant = { firstName = Empty, lastName = Empty, email = Empty, phone = Empty, resume = Empty, reason = Empty }
                                                    }
                                                )
                                        , label = text "x"
                                        }
                                    ]
                                ]
                        )
                    , paragraph [ Font.center, centerX, centerY, Font.size 17, padding 10 ]
                        [ image [ centerY, centerX, width (px 50), height (px 50) ]
                            { src = "/static/images/uploading.gif"
                            , description = "Flint"
                            }
                        ]
                    ]
                ]

        Submitted ->
            form device
                [ column [ width fill, spacingXY 0 20 ]
                    [ row [ width fill ]
                        (case device of
                            Phone ->
                                [ text "" ]

                            _ ->
                                [ column [ Font.size 20 ] [ text "Thank you" ]
                                , column [ alignRight ]
                                    [ closeButton model
                                    ]
                                ]
                        )
                    , paragraph [ Font.center, centerX, centerY, Font.size 17, padding 10 ]
                        [ case model.submissionMessage of
                            OK ->
                                text "Thank you for applying. Please check your email for the confirmation."

                            Error ->
                                text "An error occurred. Please try applying again. If the problem persists, please email us your application at careers@withflint.com"
                        ]
                    , row [ width fill ]
                        [ column
                            [ case device of
                                Phone ->
                                    centerX

                                _ ->
                                    alignRight
                            , Font.size 15
                            , padding 10
                            ]
                            [ case model.submissionMessage of
                                OK ->
                                    Input.button (buttons.primary ++ [ mouseOver [ Background.color colors.orange2 ] ])
                                        { onPress =
                                            Just
                                                (Update
                                                    { model
                                                        | applicationStatus = NotInitialized
                                                        , applicant = { firstName = Empty, lastName = Empty, email = Empty, phone = Empty, resume = Empty, reason = Empty }
                                                        , phoneView = True
                                                    }
                                                )
                                        , label = text "Done"
                                        }

                                Error ->
                                    Input.button (buttons.primary ++ [ mouseOver [ Background.color colors.orange2 ] ])
                                        { onPress = Just Submit
                                        , label = text "Retry"
                                        }
                            ]
                        ]
                    ]
                ]

        NotInitialized ->
            column [] [ text "" ]


closeButton : Model -> Element Msg
closeButton model =
    Input.button [ paddingEach { top = 0, bottom = 3, left = 5, right = 5 }, Border.rounded 2, Font.size 15, Font.color colors.red4, mouseOver [ Font.color colors.white3, Background.color colors.red4 ] ]
        { onPress =
            Just
                (Update
                    { model
                        | applicationStatus = NotInitialized
                        , error = ""
                        , applicant = { firstName = Empty, lastName = Empty, email = Empty, phone = Empty, resume = Empty, reason = Empty }
                    }
                )
        , label = text "x"
        }


newSubmissionForm : DeviceClass -> Model -> Element Msg
newSubmissionForm device model =
    form device
        [ column [ width fill, spacingXY 0 20 ]
            [ row [ width fill ]
                (case device of
                    Phone ->
                        [ column [ Font.size 15, centerX, Font.underline ]
                            [ Input.button []
                                { onPress =
                                    Just
                                        (LoadCurrentPage
                                            { model
                                                | applicationStatus = NotInitialized
                                                , error = ""
                                                , phoneView = True
                                                , applicant = { firstName = Empty, lastName = Empty, email = Empty, phone = Empty, resume = Empty, reason = Empty }
                                            }
                                        )
                                , label = text "Go Back"
                                }
                            ]
                        ]

                    _ ->
                        [ column [ Font.size 20 ] [ text "Complete application" ]
                        , column [ alignRight ]
                            [ Input.button [ paddingEach { top = 0, bottom = 3, left = 5, right = 5 }, Border.rounded 2, Font.size 15, Font.color colors.red4, mouseOver [ Font.color colors.white3, Background.color colors.red4 ] ]
                                { onPress =
                                    Just
                                        (Update
                                            { model
                                                | applicationStatus = NotInitialized
                                                , error = ""
                                                , applicant = { firstName = Empty, lastName = Empty, email = Empty, phone = Empty, resume = Empty, reason = Empty }
                                            }
                                        )
                                , label = text "x"
                                }
                            ]
                        ]
                )
            , row
                [ Font.color colors.orange1
                , case device of
                    Phone ->
                        centerX

                    _ ->
                        alignLeft
                ]
                [ text model.applicationTitle ]
            , row [ width fill, Font.size 15 ]
                [ Input.username
                    [ Border.width 1
                    , padding 7
                    , focused [ Border.color colors.orange1 ]
                    , case model.applicant.firstName of
                        Invalid ->
                            Border.color colors.red4

                        _ ->
                            Border.color colors.gray3
                    ]
                    { onChange =
                        \fname ->
                            let
                                applicant : Careers.Types.Applicant
                                applicant =
                                    model.applicant
                            in
                            Update
                                { model
                                    | applicant =
                                        { applicant
                                            | firstName = validate fname
                                        }
                                }
                    , text =
                        case model.applicant.firstName of
                            Valid fname ->
                                fname

                            _ ->
                                ""
                    , placeholder = Nothing
                    , label = Input.labelAbove [ width fill, alignTop, Font.size 15 ] <| row [] [ column [] [ text "First Name" ] ]
                    }
                ]
            , row [ width fill, Font.size 15 ]
                [ Input.username
                    [ Border.width 1
                    , padding 7
                    , focused [ Border.color colors.orange1 ]
                    , case model.applicant.lastName of
                        Invalid ->
                            Border.color colors.red4

                        _ ->
                            Border.color colors.gray3
                    ]
                    { onChange =
                        \lname ->
                            let
                                applicant : Careers.Types.Applicant
                                applicant =
                                    model.applicant
                            in
                            Update
                                { model
                                    | applicant =
                                        { applicant
                                            | lastName = validate lname
                                        }
                                }
                    , text =
                        case model.applicant.lastName of
                            Valid lname ->
                                lname

                            _ ->
                                ""
                    , placeholder = Nothing
                    , label = Input.labelAbove [ width fill, alignTop, Font.size 15 ] <| row [] [ column [] [ text "Last Name" ] ]
                    }
                ]
            , row [ width fill, Font.size 15 ]
                [ Input.email
                    [ Border.width 1
                    , padding 7
                    , focused [ Border.color colors.orange1 ]
                    , case model.applicant.email of
                        Invalid ->
                            Border.color colors.red4

                        _ ->
                            Border.color colors.gray3
                    ]
                    { onChange =
                        \email ->
                            let
                                applicant : Careers.Types.Applicant
                                applicant =
                                    model.applicant
                            in
                            Update
                                { model
                                    | applicant =
                                        { applicant
                                            | email = validateEmail email
                                        }
                                }
                    , text =
                        case model.applicant.email of
                            Valid email ->
                                email

                            _ ->
                                ""
                    , placeholder = Nothing
                    , label =
                        Input.labelAbove [ width fill, alignTop, Font.size 15 ] <|
                            row []
                                [ column [] [ text "Email" ]
                                ]
                    }
                ]
            , row [ width fill, Font.size 15 ]
                [ Input.text
                    [ Border.width 1
                    , padding 7
                    , focused [ Border.color colors.orange1 ]
                    , case model.applicant.phone of
                        Invalid ->
                            Border.color colors.red4

                        _ ->
                            Border.color colors.gray3
                    ]
                    { onChange =
                        \phone ->
                            let
                                applicant : Careers.Types.Applicant
                                applicant =
                                    model.applicant
                            in
                            Update
                                { model
                                    | applicant =
                                        { applicant
                                            | phone = validate phone
                                        }
                                }
                    , text =
                        case model.applicant.phone of
                            Valid phone ->
                                phone

                            _ ->
                                ""
                    , placeholder = Nothing
                    , label = Input.labelAbove [ width fill, alignTop, Font.size 15 ] <| row [] [ column [] [ text "Phone" ] ]
                    }
                ]
            , row [ width fill, paddingXY 0 15, Font.size 15 ]
                [ column [ width fill, spacingXY 0 10 ]
                    [ row [ width fill ]
                        [ column [] [ text <| "Resume" ]
                        , column [ Font.color colors.red3, paddingXY 10 0, Font.size 10 ]
                            [ case model.applicant.resume of
                                Valid _ ->
                                    text ""

                                Invalid ->
                                    text "Required"

                                Empty ->
                                    text ""
                            ]
                        ]
                    , row [ width fill ]
                        [ Input.button [ Font.color colors.orange1 ]
                            { onPress = Just UploadResume
                            , label = text "Upload"
                            }
                        ]
                    , row [ width fill ]
                        [ paragraph [ width <| maximum 340 fill, Font.size 13 ]
                            [ case model.applicant.resume of
                                Valid file ->
                                    text (file |> Maybe.map (\f -> File.name f) |> Maybe.withDefault "")

                                _ ->
                                    text " "
                            ]
                        ]
                    ]
                ]
            , row [ width fill, Font.size 15 ]
                [ Input.multiline
                    [ height <| px 200
                    , scrollbarY
                    , Border.width 1
                    , padding 7
                    , focused [ Border.color colors.orange1 ]
                    , case model.applicant.reason of
                        Invalid ->
                            Border.color colors.red4

                        _ ->
                            Border.color colors.gray3
                    ]
                    { onChange =
                        \reason ->
                            let
                                applicant : Careers.Types.Applicant
                                applicant =
                                    model.applicant
                            in
                            Update
                                { model
                                    | applicant =
                                        { applicant
                                            | reason = validate reason
                                        }
                                }
                    , text =
                        case model.applicant.reason of
                            Valid reason ->
                                reason

                            _ ->
                                ""
                    , placeholder = Nothing
                    , label = Input.labelAbove [ width fill, alignTop, Font.size 15 ] <| row [] [ column [] [ text "Why do you want to work at Flint?" ] ]
                    , spellcheck = False
                    }
                ]
            , row [ width fill, spacingXY 10 0 ]
                (case device of
                    Phone ->
                        [ column [ width fill, spacingXY 0 20 ]
                            [ row
                                [ centerX
                                , Font.size 15
                                ]
                                [ Input.button (buttons.primary ++ [ mouseOver [ Background.color colors.orange2 ] ])
                                    { onPress = Just Submit
                                    , label = text "Submit"
                                    }
                                ]
                            , row
                                [ centerX
                                , Font.size 13
                                , Font.color colors.red3
                                ]
                                [ row [] [ text model.error ]
                                ]
                            ]
                        ]

                    _ ->
                        [ column
                            [ Font.size 13
                            , Font.color colors.red3
                            , width fill
                            ]
                            [ paragraph [ width fill ] [ text model.error ]
                            ]
                        , column
                            [ alignRight
                            , Font.size 15
                            ]
                            [ Input.button (buttons.primary ++ [ mouseOver [ Background.color colors.orange2 ] ])
                                { onPress = Just Submit
                                , label = text "Submit"
                                }
                            ]
                        ]
                )
            ]
        ]


validate : String -> Field String
validate str =
    case str of
        "" ->
            Invalid

        _ ->
            Valid str


validateEmail : String -> Field String
validateEmail email =
    if List.length (Regex.find (Maybe.withDefault Regex.never <| Regex.fromString emailValidationString) email) <= 1 then
        Valid email

    else
        Invalid


emailValidationString : String
emailValidationString =
    "(?:[a-z0-9!#$%&'*+=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+=?^_`{|}~-]+)*|'(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*')@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
