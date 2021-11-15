module Layout exposing (footer, header, layout)

import Element
    exposing
        ( DeviceClass(..)
        , Element
        , alignBottom
        , alignLeft
        , alignRight
        , centerX
        , centerY
        , column
        , el
        , fill
        , height
        , image
        , link
        , newTabLink
        , padding
        , paddingEach
        , paddingXY
        , px
        , row
        , spacingXY
        , text
        , width
        )
import Element.Font as Font
import Router.Routes exposing (Page(..), toPath)
import Styles exposing (textStyles)


layout : { a | phone : DeviceClass -> b, tablet : DeviceClass -> b, desktop : DeviceClass -> b } -> DeviceClass -> b
layout views device =
    case device of
        Phone ->
            views.phone device

        Tablet ->
            views.tablet device

        _ ->
            views.desktop device


header : DeviceClass -> List (Element msg)
header device =
    case device of
        Phone ->
            [ row []
                [ Element.link
                    []
                    { url = toPath Home
                    , label = Element.image [ centerY, alignLeft, width (px 100), height (px 50) ] { src = "/static/images/logo.svg", description = "Flint" }
                    }
                ]
            ]

        _ ->
            [ row [ width fill ]
                [ column [ width fill ]
                    [ Element.link
                        []
                        { url = toPath Home
                        , label = Element.image [ centerY, alignLeft, width (px 100), height (px 50) ] { src = "/static/images/logo.svg", description = "Flint" }
                        }
                    ]
                , column [ width fill, alignRight ]
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


footer : DeviceClass -> List (Element msg)
footer device =
    case device of
        Phone ->
            [ row [ width fill, centerX, paddingXY 0 50 ]
                [ column ([ centerX, width fill, spacingXY 50 20, centerX, Font.size 15 ] ++ textStyles)
                    [ row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Home, label = text "Home" } ]
                    , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath FAQ, label = text "FAQ" } ]
                    , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Contact, label = text "Contact" } ]
                    , row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath Careers, label = text "Careers" } ]
                    ]
                ]
            , row [ width fill, centerX ]
                [ column [ width fill, alignBottom ]
                    [ row [ spacingXY 60 0, centerX ]
                        [ row []
                            [ newTabLink
                                []
                                { url = "https://www.ycombinator.com/companies/flint"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/YC_logo.svg", description = "Flint" }
                                }
                            ]
                        , row []
                            [ newTabLink
                                []
                                { url = "https://github.com/withflint"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/github_logo.svg", description = "Flint" }
                                }
                            ]
                        , row []
                            [ newTabLink
                                []
                                { url = "https://www.linkedin.com/company/withflint/"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/linkedin-icon-2.svg", description = "Flint" }
                                }
                            ]
                        ]
                    ]
                ]
            , row
                [ width fill, paddingEach { top = 30, bottom = 10, left = 0, right = 0 } ]
                [ image [ width (px 50), height (px 30), centerX ]
                    { src = "/static/images/logo.svg"
                    , description = "Flint"
                    }
                ]
            , row [ centerX, width fill, Font.size 10 ]
                [ el [ centerX ] <| text "© 2021 Flint, all rights reserved" ]
            ]

        _ ->
            [ row [ width fill, paddingEach { top = 100, bottom = 20, left = 0, right = 0 } ]
                [ column [ width fill ]
                    [ row
                        [ width fill
                        ]
                        [ image [ width (px 80), height (px 50) ]
                            { src = "/static/images/logo.svg"
                            , description = "Flint"
                            }
                        ]
                    , row [ width fill, Font.size 10 ]
                        [ text "© 2021 Flint, all rights reserved" ]
                    ]
                , column [ width fill, alignBottom, alignRight ]
                    [ row [ spacingXY 60 0, centerX, alignRight ]
                        [ row []
                            [ newTabLink
                                []
                                { url = "https://www.ycombinator.com/companies/flint"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/YC_logo.svg", description = "Flint" }
                                }
                            ]
                        , row []
                            [ newTabLink
                                []
                                { url = "https://github.com/withflint"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/github_logo.svg", description = "Flint" }
                                }
                            ]
                        , row []
                            [ newTabLink
                                []
                                { url = "https://www.linkedin.com/company/withflint/"
                                , label = Element.image [ centerY, alignLeft, width (px 25), height (px 25) ] { src = "/static/images/linkedin-icon-2.svg", description = "Flint" }
                                }
                            ]
                        ]
                    ]
                ]
            ]
