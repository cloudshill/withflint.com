module Home.View exposing (view)

import Element
    exposing
        ( Element
        , alignLeft
        , alignRight
        , centerX
        , clip
        , column
        , fill
        , height
        , image
        , link
        , maximum
        , minimum
        , mouseOver
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
import Home.Types exposing (Model, Msg)
import Layout exposing (layout)
import Router.Routes exposing (Page(..), toPath)
import Styles exposing (buttons, colors, heading)


view : Model -> Element Msg
view model =
    layout model.device { phone = phoneLayout, tablet = tabletLayout, desktop = desktopLayout }


tabletLayout : List (Element msg)
tabletLayout =
    [ column
        [ width fill
        , paddingXY 50 0
        , centerX
        ]
        [ column [ width fill, height fill, paddingXY 0 50, spacing 20 ]
            [ column [ centerX, width fill, width (minimum 600 shrink) ]
                [ row [ centerX ]
                    [ paragraph
                        (heading ++ [ Font.center ])
                        [ text "Competitive prices without any hassle" ]
                    ]
                , row [ centerX ]
                    [ paragraph
                        (Styles.paragraph ++ [ padding 30, Font.center, width <| maximum 600 fill ])
                        [ text "Flint is a local buying collective and purchasing service for chefs in the Greater Vancouver area. We compare dozens of wholesalers to get exactly what you need so you don't miss out on any savings." ]
                    ]
                , column ([ width fill, centerX ] ++ Styles.paragraph)
                    [ link ([ width fill, centerX, width (maximum 200 fill), Font.center, mouseOver [ Background.color colors.orange2 ] ] ++ buttons.primary)
                        { url = toPath Contact, label = text "Get in touch" }
                    , link ([ width fill, centerX, width (maximum 200 fill), Font.center, mouseOver [ Background.color colors.gray1 ] ] ++ buttons.secondary)
                        { url = toPath FAQ, label = text "FAQ" }
                    ]
                ]
            , row [ width fill, width <| maximum 600 fill, height <| maximum 600 fill, centerX ]
                [ image [ width fill ]
                    { src = "/static/images/delivery.png"
                    , description = "Delivery"
                    }
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 20, paddingEach { top = 5, bottom = 100, left = 0, right = 0 } ]
            [ row [ width fill, centerX, alignLeft ] [ row (heading ++ [ centerX, Font.size 40 ]) [ text "How it works" ] ]
            , row [ width fill, padding 30, spacingXY 0 20, alignRight, centerX ]
                [ column [ width fill, spacingXY 0 20, centerX ]
                    [ row [ centerX ] [ paragraph (Styles.paragraph ++ [ width fill, width <| maximum 600 fill ]) [ text "1. Give us your shopping list (what you need)" ] ]
                    , row [ centerX ] [ paragraph (Styles.paragraph ++ [ width fill, width <| maximum 600 fill ]) [ text "2. We compare wholesalers and find the most savings for you" ] ]
                    , row [ centerX ] [ paragraph (Styles.paragraph ++ [ width fill, width <| maximum 600 fill ]) [ text "3. You approve, we buy, it's delivered" ] ]
                    ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 30, paddingEach { top = 45, bottom = 100, left = 0, right = 0 } ]
            [ column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/online-store.png"
                        , description = "online-store"
                        }
                    ]
                , paragraph (heading ++ [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 80 fill) ]) [ text "Meats one stop shop" ]
                , paragraph (Styles.paragraph ++ [ Font.center, padding 5, width fill, height (minimum 100 fill), width <| maximum 600 fill ]) [ text "Convenient ordering of all your meats from one place" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/wishlist.png"
                        , description = "wishlist"
                        }
                    ]
                , paragraph (heading ++ [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 80 fill) ]) [ text "Single Invoice and Payment" ]
                , paragraph (Styles.paragraph ++ [ Font.center, padding 5, width fill, height (minimum 100 fill), width <| maximum 600 fill ]) [ text "Get a single itemized invoice for all your items" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/shield.png"
                        , description = "shield"
                        }
                    ]
                , paragraph (heading ++ [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 80 fill) ]) [ text "Easy Refunds and Dispute Resolution" ]
                , row [ centerX ] [ paragraph (Styles.paragraph ++ [ Font.center, padding 5, height (minimum 100 shrink), width <| maximum 600 fill ]) [ text "We'll make things right if there's something wrong with your order and represent you if the wholesaler drops the ball" ] ]
                ]
            ]
        , row [ centerX, width fill, paddingXY 0 30 ]
            [ column [ width fill, centerX, spacingXY 0 50 ]
                [ row [ width fill, centerX ] [ row (heading ++ [ centerX, Font.size 40 ]) [ text "Success Stories" ] ]
                , row [ width fill ]
                    [ column [ width fill ]
                        [ row [ width fill, padding 30 ]
                            [ image [ width fill, width <| px 100, height <| px 100, clip, Border.rounded 100, centerX ]
                                { src = "/static/images/nicholashaddad.jpg"
                                , description = "nicholashaddad"
                                }
                            ]
                        , column [ width fill, paddingXY 0 20 ]
                            [ row ([ width (maximum 600 fill), centerX ] ++ Styles.paragraph) [ paragraph [ spacingXY 0 20, Font.center ] [ text "\"I used to spend 4-8 hours each week comparing prices and placing orders. In my first week with buying through Flint, I saved over 20%! With Flint, I have full peace of mind every week that I don't miss out on any savings.\"" ] ]
                            , row [ centerX, paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ text " ??? Nicolas Haddad - Farmers Meal Catering" ]
                            ]
                        ]
                    ]
                , row [ width fill ]
                    [ column [ width fill ]
                        [ row [ width fill, padding 30 ]
                            [ image [ width fill, width <| px 100, height <| px 100, clip, Border.rounded 100, centerX ]
                                { src = "/static/images/alaia.jpg"
                                , description = "alaiafayad"
                                }
                            ]
                        , column [ width fill, paddingXY 0 20 ]
                            [ row ([ width (maximum 600 fill), centerX ] ++ Styles.paragraph) [ paragraph [ Font.center, spacingXY 0 20 ] [ text "\"Flint has been a great partner! I find the quality I am looking for at a price much lower than I can get by myself. I will save roughly $6000 or 20% this year!\"" ] ]
                            , row [ centerX, paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ text " ??? Alaia Fayad ??? Grass Roots Meal Prep" ]
                            ]
                        ]
                    ]
                ]
            ]
        , row [ Background.color colors.gray2, padding 40, width fill, Border.rounded 3, width <| maximum 800 fill, centerX ]
            [ column [ width fill, spacingXY 0 30 ]
                [ row [ centerX ] [ paragraph [ centerX, width fill, Font.size 20, Font.color colors.white3 ] [ text "Still not convinced? Try it for free, no commitment needed." ] ]
                , link (buttons.primary ++ [ centerX, padding 15, mouseOver [ Background.color colors.orange2 ] ])
                    { url = toPath Contact, label = text "Get in touch" }
                ]
            ]
        ]
    ]


phoneLayout : List (Element msg)
phoneLayout =
    [ column
        [ width fill
        , paddingXY 30 0
        , spacingXY 0 20
        ]
        [ column [ width fill, height fill, paddingXY 0 50, spacing 20 ]
            [ column [ width fill ]
                [ row [ centerX, paddingXY 10 0 ]
                    [ paragraph
                        (heading ++ [ Font.size 40, Font.center ])
                        [ text "Competitive prices without any hassle" ]
                    ]
                , paragraph
                    (Styles.paragraph ++ [ Font.center, paddingXY 0 40, width fill ])
                    [ text "Flint is a local buying collective and purchasing service for chefs in the Greater Vancouver area. We compare dozens of wholesalers to get exactly what you need so you don't miss out on any savings." ]
                , column ([ width fill, centerX ] ++ Styles.paragraph)
                    [ link ([ width fill, centerX, width (maximum 200 fill), Font.center, mouseOver [ Background.color colors.orange2 ] ] ++ buttons.primary)
                        { url = toPath Contact, label = text "Get in touch" }
                    , link ([ width fill, centerX, width (maximum 200 fill), Font.center, mouseOver [ Background.color colors.gray1 ] ] ++ buttons.secondary)
                        { url = toPath FAQ, label = text "FAQ" }
                    ]
                ]
            , row [ width fill ]
                [ image [ width fill ]
                    { src = "/static/images/delivery.png"
                    , description = "Delivery"
                    }
                ]
            ]
        , column [ width fill, paddingXY 0 50 ]
            [ row [ width fill, centerX, alignLeft ] [ row (heading ++ [ centerX, Font.size 40 ]) [ text "How it works" ] ]
            , row [ width fill, padding 30, spacingXY 0 20, alignRight ]
                [ column [ width fill, spacingXY 0 20 ]
                    [ row [ centerX ] [ paragraph (Styles.paragraph ++ [ Font.center, width fill ]) [ text "1. Give us your shopping list (what you need)" ] ]
                    , row [ centerX ] [ paragraph (Styles.paragraph ++ [ Font.center, width fill ]) [ text "2. We compare wholesalers and find the most savings for you" ] ]
                    , row [ centerX ] [ paragraph (Styles.paragraph ++ [ Font.center, width fill ]) [ text "3. You approve, we buy, it's delivered" ] ]
                    ]
                ]
            ]
        , column [ width fill, paddingXY 0 50, spacingXY 30 30 ]
            [ column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/online-store.png"
                        , description = "online-store"
                        }
                    ]
                , paragraph (heading ++ [ Font.size 25, Font.center, paddingXY 0 20 ]) [ text "Meats one stop shop" ]
                , paragraph (Styles.paragraph ++ [ Font.center, padding 5, height (minimum 100 fill) ]) [ text "Convenient ordering of all your meats from one place" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/wishlist.png"
                        , description = "wishlist"
                        }
                    ]
                , paragraph (heading ++ [ Font.size 25, Font.center, paddingXY 0 20 ]) [ text "Single Invoice and Payment" ]
                , paragraph (Styles.paragraph ++ [ Font.center, padding 5, height (minimum 100 fill) ]) [ text "Get a single itemized invoice for all your items" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                , width <| maximum 600 fill
                , centerX
                ]
                [ row [ centerX, height (minimum 120 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/shield.png"
                        , description = "shield"
                        }
                    ]
                , paragraph
                    (heading
                        ++ [ Font.size 25
                           , Font.center
                           , paddingXY 20 20
                           ]
                    )
                    [ text "Easy Refunds and Dispute Resolution" ]
                , row [ centerX, width fill ] [ paragraph (Styles.paragraph ++ [ Font.center, padding 5, height (minimum 100 fill) ]) [ text "We'll make things right if there's something wrong with your order and represent you if the wholesaler drops the ball" ] ]
                ]
            ]
        , row [ centerX, width fill, paddingXY 0 30 ]
            [ column [ width fill, centerX, spacingXY 0 30 ]
                [ row [ width fill, centerX, paddingXY 0 20 ] [ row (heading ++ [ centerX, Font.size 40 ]) [ text "Success Stories" ] ]
                , row [ width fill ]
                    [ column [ width fill ]
                        [ row [ width fill ]
                            [ image [ width fill, width <| px 100, height <| px 100, clip, Border.rounded 100, centerX ]
                                { src = "/static/images/nicholashaddad.jpg"
                                , description = "nicholashaddad"
                                }
                            ]
                        , column [ width fill, paddingXY 0 20 ]
                            [ row [ width (maximum 400 fill), centerX ] [ paragraph ([ spacingXY 0 20, Font.center ] ++ Styles.paragraph) [ text "\"I used to spend 4-8 hours each week comparing prices and placing orders. In my first week with buying through Flint, I saved over 20%! With Flint, I have full peace of mind every week that I don't miss out on any savings.\"" ] ]
                            , row [ centerX, paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ paragraph [] [ text "Nicolas Haddad" ] ]
                            ]
                        ]
                    ]
                , row [ width fill ]
                    [ column [ width fill ]
                        [ row [ width fill ]
                            [ image [ width fill, width <| px 100, height <| px 100, clip, Border.rounded 100, centerX ]
                                { src = "/static/images/alaia.jpg"
                                , description = "alaiafayad"
                                }
                            ]
                        , column [ width fill, paddingXY 0 20 ]
                            [ row [ width (maximum 400 fill), centerX ] [ paragraph ([ spacingXY 0 20, Font.center ] ++ Styles.paragraph) [ text "\"Flint has been a great partner! I find the quality I am looking for at a price much lower than I can get by myself. I will save roughly $6000 or 20% this year!\"" ] ]
                            , column [ centerX, paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ paragraph [] [ text "Alaia Fayad" ] ]
                            ]
                        ]
                    ]
                ]
            ]
        , row [ Background.color colors.gray2, padding 30, width fill, Border.rounded 3 ]
            [ column [ width fill, spacingXY 0 30 ]
                [ paragraph [ Font.center, width fill, Font.size 16, Font.color colors.white3 ] [ text "Still not convinced? Try it for free, no commitment needed." ]
                , link (buttons.primary ++ [ centerX, padding 15, mouseOver [ Background.color colors.orange2 ] ])
                    { url = toPath Contact, label = text "Get in touch" }
                ]
            ]
        ]
    ]


desktopLayout : List (Element msg)
desktopLayout =
    [ column
        [ width fill
        , height fill
        , centerX
        ]
        [ row [ width fill, paddingXY 0 80, spacing 10 ]
            [ column [ width fill, width (minimum 600 shrink) ]
                [ paragraph
                    heading
                    [ text "Competitive prices without any hassle" ]
                , paragraph
                    (Styles.paragraph ++ [ paddingXY 0 40 ])
                    [ text "Flint is a local buying collective and purchasing service for chefs in the Greater Vancouver area. We compare dozens of wholesalers to get exactly what you need so you don't miss out on any savings." ]
                , row (width fill :: Styles.paragraph)
                    [ link ([ Font.center, width fill, width (maximum 200 fill), mouseOver [ Background.color colors.orange2 ] ] ++ buttons.primary)
                        { url = toPath Contact, label = text "Get in touch" }
                    , link ([ Font.center, width fill, width (maximum 200 fill), mouseOver [ Background.color colors.gray1 ] ] ++ buttons.secondary)
                        { url = toPath FAQ, label = text "FAQ" }
                    ]
                ]
            , column [ width fill ]
                [ image [ width fill ]
                    { src = "/static/images/delivery.png"
                    , description = "Delivery"
                    }
                ]
            ]
        , column [ width fill, paddingXY 0 100, spacingXY 0 10 ]
            [ row [ width fill, width (minimum 600 shrink) ] [ row heading [ text "How it works" ] ]
            , row [] [ paragraph (Styles.paragraph ++ [ paddingXY 5 0, width fill ]) [ text "1. Give us your shopping list (what you need)" ] ]
            , row [] [ paragraph (Styles.paragraph ++ [ paddingXY 5 0, width fill ]) [ text "2. We compare wholesalers and find the most savings for you" ] ]
            , row [] [ paragraph (Styles.paragraph ++ [ paddingXY 5 0, width fill ]) [ text "3. You approve, we buy, it's delivered" ] ]
            ]
        , row [ width fill, paddingXY 0 100, spacingXY 70 0 ]
            [ column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                ]
                [ row [ centerX, height (minimum 200 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/online-store.png"
                        , description = "online-store"
                        }
                    ]
                , paragraph [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 100 fill) ] [ text "Meats one stop shop" ]
                , paragraph (Styles.paragraph ++ [ Font.center, height (minimum 100 fill) ]) [ text "Convenient ordering of all your meats from one place" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                ]
                [ row [ centerX, height (minimum 200 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/wishlist.png"
                        , description = "wishlist"
                        }
                    ]
                , paragraph [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 100 fill) ] [ text "Single Invoice and Payment" ]
                , paragraph (Styles.paragraph ++ [ Font.center, height (minimum 100 fill) ]) [ text "Get a single itemized invoice for all your items" ]
                ]
            , column
                [ width fill
                , Border.color colors.white2
                , Border.rounded 3
                , Border.shadow
                    { offset = ( 0, 0 )
                    , size = 2
                    , blur = 8
                    , color = colors.gray3
                    }
                , padding 30
                ]
                [ row [ centerX, height (minimum 200 fill) ]
                    [ image [ width fill ]
                        { src = "/static/images/shield.png"
                        , description = "shield"
                        }
                    ]
                , paragraph [ Font.size 25, Font.center, paddingXY 0 20, height (minimum 100 fill) ] [ text "Easy Refunds and Dispute Resolution" ]
                , paragraph (Styles.paragraph ++ [ Font.center, height (minimum 100 shrink) ]) [ text "We'll make things right if there's something wrong with your order and represent you if the wholesaler drops the ball" ]
                ]
            ]
        , row [ width fill, paddingXY 0 100, spacing 10, width <| minimum 1000 fill ]
            [ column [ width fill ]
                [ row [ width fill ] [ paragraph heading [ text "Success Stories" ] ]
                , row [ padding 30 ]
                    [ column [ centerX, paddingEach { top = 0, bottom = 0, left = 0, right = 50 } ]
                        [ image [ width fill, centerX, width <| px 120, height <| px 120, clip, Border.rounded 100 ]
                            { src = "/static/images/nicholashaddad.jpg"
                            , description = "nicholashaddad"
                            }
                        ]
                    , column [ width fill, paddingEach { top = 0, bottom = 0, left = 20, right = 0 }, centerX ]
                        [ paragraph (Styles.paragraph ++ [ spacingXY 0 10, width <| minimum 900 fill, width fill ]) [ text "\"I used to spend 4-8 hours each week comparing prices and placing orders. In my first week with buying through Flint, I saved over 20%! With Flint, I have full peace of mind every week that I don't miss out on any savings.\"" ]
                        , row [ paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ text " ??? Nicolas Haddad - Farmers Meal Catering" ]
                        ]
                    ]
                , row [ padding 30 ]
                    [ column [ centerX, paddingEach { top = 0, bottom = 0, left = 0, right = 50 } ]
                        [ image [ width fill, centerX, width <| px 120, height <| px 120, clip, Border.rounded 100 ]
                            { src = "/static/images/alaia.jpg"
                            , description = "alaia"
                            }
                        ]
                    , column [ width fill, paddingEach { top = 0, bottom = 0, left = 20, right = 0 }, centerX ]
                        [ paragraph (Styles.paragraph ++ [ spacingXY 0 10, width <| minimum 900 fill, width fill ]) [ text "\"Flint has been a great partner! I find the quality I am looking for at a price much lower than I can get by myself. I will save roughly $6000 or 20% this year!\"" ]
                        , row [ paddingXY 0 20, Font.color colors.orange1, Font.bold ] [ text " ??? Alaia Fayad - Grass Roots Meal Prep" ]
                        ]
                    ]
                ]
            ]
        , row [ Background.color colors.gray2, padding 30, width fill, Border.rounded 3 ]
            [ paragraph [ paddingXY 20 0, centerX, width fill, Font.color colors.white3 ] [ text "Still not convinced? Try it for free, no commitment needed." ]
            , link (buttons.primary ++ [ alignLeft, padding 15, mouseOver [ Background.color colors.orange2 ] ])
                { url = toPath Contact, label = text "Get in touch" }
            ]
        ]
    ]
