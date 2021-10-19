module Careers.View exposing (view)

import Careers.Types exposing (JobsStatus(..), Model, Msg)
import Element
    exposing
        ( DeviceClass
        , Element
        , alignLeft
        , alignRight
        , alignTop
        , centerX
        , column
        , fill
        , height
        , maximum
        , minimum
        , mouseOver
        , newTabLink
        , padding
        , paddingEach
        , paddingXY
        , paragraph
        , row
        , shrink
        , spacing
        , spacingXY
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Layout exposing (footer, header, layout)
import List
import Styles exposing (colors, heading)


view : Model -> Element Msg
view model =
    column [ height fill, width fill ] (layout { phone = phoneLayout, tablet = tabletLayout, desktop = desktopLayout } model.device.class model)


jobPhoneView : { a | title : String, location : String, equity : String, experience : String, url : String } -> Element msg
jobPhoneView job =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10, width fill, paddingXY 10 0 ]
            [ row [ Font.color colors.orange1, width <| maximum 300 fill ]
                [ paragraph [] [ text job.title ]
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
            [ newTabLink
                [ Border.color colors.orange1
                , Border.width 1
                , Border.rounded 2
                , padding 10
                , Font.size 15
                , Font.color colors.white3
                , Background.color colors.orange1
                , mouseOver [ Background.color colors.orange2 ]
                ]
                { url = job.url
                , label = text "Apply Now"
                }
            ]
        ]


phoneLayout : DeviceClass -> Model -> List (Element msg)
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
            (case model.jobs of
                Results jobs ->
                    jobs
                        |> List.map
                            (\job -> row [ centerX, width fill ] [ jobPhoneView job ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , column [ width fill ] (footer device)
        ]
    ]


tabletLayout : DeviceClass -> Model -> List (Element msg)
tabletLayout device model =
    [ column
        [ width fill
        , paddingXY 50 0
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
                            (\job -> column [ width fill, centerX ] [ jobView job ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill ] (footer device)
        ]
    ]


jobView : { a | title : String, location : String, equity : String, experience : String, url : String } -> Element msg
jobView job =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10 ]
            [ row [ Font.color colors.orange1 ]
                [ text job.title
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
            [ newTabLink
                [ Border.color colors.orange1
                , Border.width 1
                , Border.rounded 2
                , padding 10
                , Font.size 15
                , Font.color colors.white3
                , Background.color colors.orange1
                , mouseOver [ Background.color colors.orange2 ]
                ]
                { url = job.url
                , label = text "Apply Now"
                }
            ]
        ]


desktopLayout : DeviceClass -> Model -> List (Element msg)
desktopLayout device model =
    [ column
        [ width fill
        , paddingXY 100 0
        , centerX
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
                            (\job -> column [ width fill, centerX ] [ jobView job ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill ] (footer device)
        ]
    ]
