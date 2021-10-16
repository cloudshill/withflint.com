module Careers.View exposing (view)

import Careers.Types exposing (JobsStatus(..), Model, Msg)
import Element
    exposing
        ( DeviceClass(..)
        , Element
        , alignBottom
        , alignLeft
        , alignRight
        , alignTop
        , centerX
        , centerY
        , column
        , el
        , fill
        , height
        , image
        , link
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
        , shrink
        , spacing
        , spacingXY
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import List
import Router.Routes exposing (Page(..), toPath)
import Styles exposing (colors, heading, textStyles)


view : Model -> Element Msg
view model =
    let
        responsiveLayout : List (Element msg)
        responsiveLayout =
            case ( model.device.class, model.device.orientation ) of
                ( Desktop, _ ) ->
                    desktopLayout model

                ( Phone, _ ) ->
                    phoneLayout model

                ( Tablet, _ ) ->
                    tabletLayout model

                ( BigDesktop, _ ) ->
                    desktopLayout model
    in
    column [ height fill, width fill ] responsiveLayout


jobPhoneView : { a | title : String, location : String, equity : String, experience : String, url : String } -> Element msg
jobPhoneView job =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10, width fill ]
            [ row [ Font.color colors.orange, width fill ]
                [ text job.title
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
            [ Border.color colors.orange
            , Border.width 1
            , Border.rounded 2
            , padding 10
            , Font.size 15
            , Font.color colors.orange
            , mouseOver [ Background.color colors.orange, Font.color colors.white3 ]
            , alignTop
            , alignRight
            ]
            [ newTabLink
                []
                { url = job.url
                , label = text "Apply Now"
                }
            ]
        ]


phoneLayout : Model -> List (Element msg)
phoneLayout model =
    [ column
        [ width fill
        , paddingXY 30 0
        , spacingXY 0 20
        ]
        [ row []
            [ Element.link
                []
                { url = toPath Home
                , label = Element.image [ centerY, alignLeft, width (px 100), height (px 50) ] { src = "/images/logo.svg", description = "Flint" }
                }
            ]
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
        , row [ width fill, centerX, paddingXY 0 50 ]
            [ column ([ centerX, width fill, spacingXY 50 20, centerX, Font.size 15 ] ++ textStyles)
                [ row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Home, label = text "Home" } ]
                , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath FAQ, label = text "FAQ" } ]
                , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Contact, label = text "Contact" } ]
                , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Careers, label = text "Careers" } ]
                ]
            ]
        , row [ width fill, centerX ]
            [ column [ width fill, alignBottom ]
                [ row [ spacingXY 20 0, centerX ]
                    [ row []
                        [ newTabLink
                            []
                            { url = "https://www.ycombinator.com/companies/flint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/YC_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://github.com/withflint/withflint.com"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/github_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://www.linkedin.com/company/withflint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/linkedin-icon-2.svg", description = "Flint" }
                            }
                        ]
                    ]
                ]
            ]
        , row
            [ width fill, paddingEach { top = 30, bottom = 10, left = 0, right = 0 } ]
            [ image [ width (px 50), height (px 30), centerX ]
                { src = "/images/logo.svg"
                , description = "Flint"
                }
            ]
        , row [ centerX, width fill, Font.size 10 ]
            [ el [ centerX ] <| text "© 2021 Flint, all rights reserved" ]
        ]
    ]


tabletLayout : Model -> List (Element msg)
tabletLayout model =
    [ column
        [ width fill
        , paddingXY 50 0
        ]
        [ row []
            [ Element.link
                []
                { url = toPath Home
                , label = Element.image [ centerY, alignLeft, width (px 100), height (px 50) ] { src = "/images/logo.svg", description = "Flint" }
                }
            ]
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
                            (\job -> column [ width <| maximum 700 fill, centerX ] [ jobView job ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill, paddingEach { top = 100, bottom = 20, left = 0, right = 0 } ]
            [ column [ width fill ]
                [ row
                    [ width fill
                    ]
                    [ image [ width (px 80), height (px 50) ]
                        { src = "/images/logo.svg"
                        , description = "Flint"
                        }
                    ]
                , row [ width fill, Font.size 10 ]
                    [ text "© 2021 Flint, all rights reserved" ]
                ]
            , column [ width fill, alignBottom ]
                [ row [ spacingXY 20 0, centerX, paddingXY 40 0 ]
                    [ row []
                        [ newTabLink
                            []
                            { url = "https://www.ycombinator.com/companies/flint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/YC_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://github.com/withflint/withflint.com"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/github_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://www.linkedin.com/company/withflint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/linkedin-icon-2.svg", description = "Flint" }
                            }
                        ]
                    ]
                ]
            , column [ width fill, alignBottom ]
                [ column (width fill :: textStyles)
                    [ row [ spacingXY 30 0, alignRight ]
                        [ row [] [ link [ padding 5 ] { url = toPath Home, label = text "Home" } ]
                        , row [] [ link [ padding 5 ] { url = toPath FAQ, label = text "FAQ" } ]
                        , row [] [ link [ padding 5 ] { url = toPath Contact, label = text "Contact" } ]
                        , row [] [ link [ padding 5 ] { url = toPath Careers, label = text "Careers" } ]
                        ]
                    ]
                ]
            ]
        ]
    ]


jobView : { a | title : String, location : String, equity : String, experience : String, url : String } -> Element msg
jobView job =
    row [ width fill ]
        [ column [ alignLeft, spacingXY 0 10 ]
            [ row [ Font.color colors.orange ]
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
            , Border.color colors.orange
            , Border.width 1
            , Border.rounded 2
            , padding 10
            , Font.size 15
            , Font.color colors.orange
            , mouseOver [ Background.color colors.orange, Font.color colors.white3 ]
            ]
            [ newTabLink
                []
                { url = job.url
                , label = text "Apply Now"
                }
            ]
        ]


desktopLayout : Model -> List (Element msg)
desktopLayout model =
    [ column
        [ width fill
        , paddingXY 100 0
        , centerX
        ]
        [ row [ width fill, centerX ]
            [ Element.link
                [ width fill ]
                { url = toPath Home
                , label = Element.image [ centerY, alignLeft, width (px 100), height (px 50) ] { src = "/images/logo.svg", description = "Flint" }
                }
            ]
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
                            (\job -> column [ width <| maximum 1000 fill, centerX ] [ jobView job ])

                Loading ->
                    [ row [] [ text "Loading ..." ] ]

                NoJobs ->
                    [ row [] [ text "No Jobs" ] ]
            )
        , row [ width fill, paddingEach { top = 100, bottom = 20, left = 0, right = 0 } ]
            [ column [ width fill ]
                [ row
                    [ width fill
                    ]
                    [ image [ width (px 80), height (px 50) ]
                        { src = "/images/logo.svg"
                        , description = "Flint"
                        }
                    ]
                , row [ width fill, Font.size 10 ]
                    [ text "© 2021 Flint, all rights reserved" ]
                ]
            , column [ width fill, alignBottom ]
                [ row [ spacingXY 20 0, centerX ]
                    [ row []
                        [ newTabLink
                            []
                            { url = "https://www.ycombinator.com/companies/flint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/YC_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://github.com/withflint/withflint.com"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/github_logo.svg", description = "Flint" }
                            }
                        ]
                    , row []
                        [ newTabLink
                            []
                            { url = "https://www.linkedin.com/company/withflint"
                            , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/images/linkedin-icon-2.svg", description = "Flint" }
                            }
                        ]
                    ]
                ]
            , column [ width fill, alignBottom ]
                [ column (width fill :: textStyles)
                    [ row [ spacingXY 30 0, alignRight ]
                        [ row [] [ link [ padding 5 ] { url = toPath Home, label = text "Home" } ]
                        , row [] [ link [ padding 5 ] { url = toPath FAQ, label = text "FAQ" } ]
                        , row [] [ link [ padding 5 ] { url = toPath Contact, label = text "Contact" } ]
                        , row [] [ link [ padding 5 ] { url = toPath Careers, label = text "Careers" } ]
                        ]
                    ]
                ]
            ]
        ]
    ]
