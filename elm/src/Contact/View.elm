module Contact.View exposing (view)

import Contact.Types exposing (Model, Msg)
import Element
    exposing
        ( DeviceClass
        , Element
        , centerX
        , column
        , el
        , fill
        , height
        , link
        , maximum
        , minimum
        , mouseOver
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
import Styles exposing (buttons, colors, heading, textStyles)


view : Model -> Element Msg
view model =
    column [ height fill, width fill ] (layout { phone = phoneLayout, tablet = tabletLayout, desktop = desktopLayout } model.device.class)


phoneLayout : DeviceClass -> List (Element msg)
phoneLayout device =
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
                    [ text "Contact Us" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 20 ]
            [ row
                [ width fill
                , height fill
                , paddingXY 10 10
                , spacingXY 20 20
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , height <| minimum 500 fill
                , width <| maximum 700 fill
                , centerX
                ]
                [ column [ width fill, spacingXY 0 15, paddingXY 0 20 ]
                    [ row (heading ++ [ centerX, Font.size 30, Font.color colors.orange1 ]) [ text "Sales" ]
                    , row [ centerX ] [ paragraph (textStyles ++ [ Font.center, paddingXY 40 30, height <| minimum 120 fill ]) [ text "To learn more and evaluate if you can save money with Flint, simply reach out to our friendly sales team." ] ]
                    , link (textStyles ++ buttons.primary ++ [ width <| maximum 200 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.orange2 ] ]) { url = "mailto:sales@withflint.com", label = text "sales@withflint.com" }
                    , link (textStyles ++ buttons.secondary ++ [ width <| maximum 200 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.gray1 ] ]) { url = "tel:+1 (604) 200-6482", label = text "+1 (604) 200-6482" }
                    ]
                ]
            , row
                [ width fill
                , height fill
                , paddingXY 10 10
                , spacingXY 20 20
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , height <| minimum 600 fill
                , width <| maximum 700 fill
                , centerX
                ]
                [ column [ width fill, spacingXY 0 15, paddingXY 0 20 ]
                    [ row (heading ++ [ centerX, Font.size 30, Font.color colors.orange1 ]) [ text "Account Management" ]
                    , row [ centerX ] [ paragraph (textStyles ++ [ Font.center, paddingXY 40 30, height <| minimum 120 fill ]) [ text "Already a customer?\nWe are committed to taking care of you, whether it's basic questions or last minute emergencies. We are on your team to help find savings for exactly what you want, week in and week out. Text, call or email us!" ] ]
                    , link (textStyles ++ buttons.primary ++ [ width <| maximum 200 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.orange2 ] ]) { url = "mailto:order@withflint.com", label = text "order@withflint.com" }
                    , link (textStyles ++ buttons.secondary ++ [ width <| maximum 200 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.gray1 ] ]) { url = "tel:+1 (604) 245-8168", label = text "+1 (604) 245-8168" }
                    ]
                ]
            ]
        , column [ width fill ] (footer device)
        ]
    ]


tabletLayout : DeviceClass -> List (Element msg)
tabletLayout device =
    [ column
        [ width fill
        , paddingXY 50 0
        ]
        [ row [ width fill ] (header device)
        , row [ width fill, height fill, paddingXY 0 50 ]
            [ column [ centerX, width fill, width (minimum 600 shrink) ]
                [ row
                    (heading ++ [ centerX ])
                    [ text "Contact Us" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 20 ]
            [ row
                [ width fill
                , height fill
                , paddingXY 10 10
                , spacingXY 20 20
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , height <| minimum 500 fill
                , width <| maximum 700 fill
                , centerX
                ]
                [ column
                    [ width fill
                    , spacingXY 0 25
                    , paddingXY 0 40
                    ]
                    [ row (heading ++ [ centerX, Font.size 30, height <| minimum 50 fill, Font.color colors.orange1 ]) [ text "Sales" ]
                    , row [ width <| maximum 500 fill, centerX ] [ paragraph (textStyles ++ [ Font.center, paddingXY 40 0, height <| minimum 120 fill ]) [ text "To learn more and evaluate if you can save money with Flint, simply reach out to our friendly sales team." ] ]
                    , link (textStyles ++ buttons.primary ++ [ width <| maximum 300 fill, Font.color colors.white3, Font.center, centerX, mouseOver [ Background.color colors.orange2 ] ]) { url = "mailto:sales@withflint.com", label = text "sales@withflint.com" }
                    , link (textStyles ++ buttons.secondary ++ [ width <| maximum 300 fill, Font.color colors.white3, Font.center, centerX, mouseOver [ Background.color colors.gray1 ] ]) { url = "tel:+1 (604) 200-6482", label = text "+1 (604) 200-6482" }
                    ]
                ]
            , row
                [ width fill
                , height fill
                , paddingXY 10 10
                , spacingXY 20 20
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , height <| minimum 500 fill
                , width <| maximum 700 fill
                , centerX
                ]
                [ column
                    [ width fill
                    , spacingXY 0 25
                    , paddingXY 0 40
                    ]
                    [ row (heading ++ [ centerX, Font.size 30, height <| minimum 80 fill, Font.color colors.orange1 ]) [ text "Account Management" ]
                    , row [ width <| maximum 500 fill, centerX ] [ paragraph (textStyles ++ [ Font.center, paddingEach { left = 40, right = 40, top = 0, bottom = 30 }, height <| minimum 120 fill ]) [ text "Already a customer?We are committed to taking care of you, whether it's basic questions or last minute emergencies. We are on your team to help find savings for exactly what you want, week in and week out. Text, call or email us!" ] ]
                    , link (textStyles ++ buttons.primary ++ [ width <| maximum 300 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.orange2 ] ]) { url = "mailto:order@withflint.com", label = text "order@withflint.com" }
                    , link (textStyles ++ buttons.secondary ++ [ width <| maximum 300 fill, Font.color colors.white3, centerX, Font.center, mouseOver [ Background.color colors.gray1 ] ]) { url = "tel:+1 (604) 245-8168", label = text "+1 (604) 245-8168" }
                    ]
                ]
            ]
        , row [ width fill ] (footer device)
        ]
    ]


desktopLayout : DeviceClass -> List (Element msg)
desktopLayout device =
    [ column
        [ width fill
        , paddingXY 100 0
        , centerX
        ]
        [ row [ width fill ] (header device)
        , row [ width fill, height fill, paddingXY 0 100, spacing 10 ]
            [ column [ width fill, width (minimum 600 shrink) ]
                [ paragraph
                    heading
                    [ text "Contact Us" ]
                ]
            ]
        , row [ width fill, height fill, spacingXY 20 20, paddingEach { top = 5, bottom = 120, left = 0, right = 0 } ]
            [ column
                [ width fill
                , centerX
                , height (minimum 300 fill)
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , spacingXY 0 20
                ]
                [ row (heading ++ [ centerX, Font.size 30, Font.color colors.orange1 ]) [ text "Sales" ]
                , row [ paddingEach { top = 50, bottom = 0, left = 0, right = 0 }, centerX ] [ paragraph (textStyles ++ [ Font.center, height <| minimum 200 fill ]) [ text "To learn more and evaluate if you can save money with Flint, simply reach out to our friendly sales team." ] ]
                , row (textStyles ++ [ centerX, width <| maximum 300 fill, Font.size 20, Font.color colors.gray2, Border.rounded 3 ]) [ el [ centerX ] <| text "sales@withflint.com" ]
                , row (textStyles ++ [ centerX, width <| maximum 300 fill, Font.size 20, Font.color colors.gray2, Border.rounded 3 ]) [ el [ centerX ] <| text "+1 (604) 200-6482" ]
                ]
            , column
                [ width fill
                , height (minimum 300 fill)
                , centerX
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , spacingXY 0 20
                ]
                [ row (heading ++ [ centerX, Font.size 30, Font.color colors.orange1 ]) [ text "Account Management" ]
                , row [ paddingEach { top = 50, bottom = 0, left = 0, right = 0 } ] [ paragraph (textStyles ++ [ Font.center, height <| minimum 200 fill ]) [ text "Already a customer?\nWe are committed to taking care of you, whether it's basic questions or last minute emergencies. We are on your team to help find savings for exactly what you want, week in and week out. Text, call or email us!" ] ]
                , row (textStyles ++ [ centerX, width <| maximum 300 fill, Font.size 20, Font.color colors.gray2 ]) [ el [ centerX ] <| text "order@withflint.com" ]
                , row (textStyles ++ [ centerX, width <| maximum 300 fill, Font.size 20, Border.rounded 3, Font.color colors.gray2 ]) [ el [ centerX ] <| text "+1 (604) 245-8168" ]
                ]
            ]
        , row [ width fill ] (footer device)
        ]
    ]
