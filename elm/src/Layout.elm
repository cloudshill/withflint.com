module Layout exposing (footer, layout, topMenu)

import Device exposing (Device(..))
import Element
    exposing
        ( Element
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
import Styles


topMenu : List ( Page, String )
topMenu =
    [ ( Home, "Home" )
    , ( FAQ, "FAQ" )
    , ( Contact, "Contact" )
    , ( Blog "", "Blog" )
    , ( Jobs, "Jobs" )
    ]


fillxy : List (Element.Attribute msg)
fillxy =
    [ height fill, width fill, alignTop ]


layout : Device -> { a | phone : List (Element msg), tablet : List (Element msg), desktop : List (Element msg) } -> Element msg
layout device views =
    case device of
        Phone ->
            column
                (fillxy
                    ++ [ centerX
                       , alignTop
                       , width fill
                       , height fill
                       ]
                )
                [ row [ width fill, paddingXY 20 40 ] (header device)
                , row fillxy views.phone
                , column [ width fill ] (footer device)
                ]

        Tablet ->
            column
                (fillxy
                    ++ [ centerX
                       , alignTop
                       , paddingXY 100 40
                       , width <| maximum 1500 fill
                       , height fill
                       ]
                )
                [ row [ width fill ] (header device)
                , row fillxy views.tablet
                , row [ width fill ] (footer device)
                ]

        _ ->
            column
                (fillxy
                    ++ [ centerX
                       , alignTop
                       , paddingXY 100 40
                       , width <| maximum 1500 fill
                       , height fill
                       ]
                )
                [ row [ width fill ] (header device)
                , row fillxy views.desktop
                , row [ width fill ] (footer device)
                ]


header : Device -> List (Element msg)
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
                    [ column (width fill :: Styles.paragraph)
                        [ row [ spacingXY 30 0, alignRight ]
                            (topMenu |> List.map (\( path, label ) -> row [] [ link [ padding 5 ] { url = toPath path, label = text label } ]))
                        ]
                    ]
                ]
            ]


footer : Device -> List (Element msg)
footer device =
    case device of
        Phone ->
            [ row [ width fill, centerX, paddingXY 0 50 ]
                [ column ([ centerX, width fill, spacingXY 50 20, centerX, Font.size 15 ] ++ Styles.paragraph)
                    (topMenu |> List.map (\( path, label ) -> row [ width fill, centerX ] [ link [ centerX, padding 5 ] { url = toPath path, label = text label } ]))
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
            , row [ centerX, width fill, Font.size 10, paddingXY 0 10 ]
                [ el [ centerX ] <| text "© 2021 Flint, all rights reserved" ]
            ]

        _ ->
            [ row [ height fill ] []
            , row [ width fill, paddingEach { top = 100, bottom = 20, left = 0, right = 0 } ]
                [ column [ width fill ]
                    [ row
                        [ width fill
                        ]
                        [ image [ width (px 80), height (px 50) ]
                            { src = "/static/images/logo.svg"
                            , description = "Flint"
                            }
                        ]
                    , row [ width fill, Font.size 10, paddingXY 0 10 ]
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
