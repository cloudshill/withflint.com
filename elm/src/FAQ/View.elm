module FAQ.View exposing (view)

import Element
    exposing
        ( Element
        , centerX
        , column
        , fill
        , height
        , maximum
        , minimum
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
import Element.Border as Border
import Element.Font as Font
import FAQ.Types exposing (Model, Msg)
import Layout exposing (layout)
import Styles exposing (colors, heading)


data : List ( String, String )
data =
    [ ( "Who is Flint for?"
      , "Chefs who want to save time and money purchasing from independent wholesalers. If you find yourself spending hours comparing pricing, or if you have given up trying to get competitive pricing every week and have settled with a few suppliers, then this is a great fit for you!"
      )
    , ( "What happens in case if something is missing from my order or the quality of the ingredients is bad?"
      , "If something is missing or bad you can connect directly with your account manager to rectify any issue. As a collective we are able to help advocate on your behalf with wholesalers, with strength in numbers, when needed."
      )
    , ( "What type of products can I order on The Collective?"
      , "Today we’re focused on working with meat and seafood wholesalers. In the future, we’ll be adding produce and dry goods wholesalers to our network. Our goal is to be a one stop shop for all your purchasing needs."
      )
    , ( "How do you get better prices?"
      , "As a collective we are able to use the group buying power to negotiate price savings for everyone. We work with most of the wholesalers in lower mainland to get up-to-date pricing every time you order! Comparing so many suppliers assures that you are not missing out on any savings.\n\n"
      )
    , ( "How much does this cost? How do you make money?"
      , "We make money by finding you savings, and then sharing in those savings 50/50 for the first 3 months. After 3 months, we take a small fee of cost + 5%. For example, if we can help you save $100 on your order, we would split that half-half, so $50 for you, and $50 for us. After 3 months, our share will drop to a cost + 5% model. It takes a lot of work to stay on top of the best prices as the market is changing all the time, so these fees help us cover the costs of helping you manage relationships with wholesalers, negotiating prices on your behalf, and always finding you the best prices every week.\n\n"
      )
    , ( "Do I have to sign a contract? Can I stop ordering?"
      , "You do not need to sign a contract, and you can stop purchasing through us at any time. Our goal is to win your business by providing the absolute best service and prices in town, and by consistently doing that month after month, year after year. If you are not satisfied with our service, you can stop purchasing from us at any time."
      )
    , ( "Are there order minimums or delivery fees?"
      , "We automatically take all that information into account when finding you the best source for your order. Standard industry minimums and delivery fees still apply.\n\n"
      )
    , ( "What are the payment terms?"
      , "Net-7 payment terms. We also offer Net 30 terms for a small fee of $10/order. This helps us cover the additional financing and banking fees we accrue in order to provide you with Net 30 terms.\nDirect Autopayment approved on purchase.\n\n"
      )
    , ( "How do I pay?"
      , "We’ll send you a form to fill out to set up pre-authorized debit. This is the most convenient and cost effective way for you to pay. We do not accept credit cards because of the additional fees that are charged by the big credit card companies, which will eventually be passed on to you through higher prices or fees. Our goal is to help you save as much money as possible, and supporting credit cards goes against this."
      )
    , ( "Which days can I get delivery?"
      , "We'll be able to find the best wholesalers for you any day of the week."
      )
    , ( "When is the order deadline?"
      , "The order deadline is 11:00am to guarantee next day delivery. The earlier you place your order, the better pricing you can get. This is because every wholesaler has different order deadlines, so the earlier you place your order, the more price lists we can compare for you."
      )
    ]


view : Model -> Element Msg
view model =
    layout model.device { phone = phoneLayout, tablet = tabletLayout, desktop = desktopLayout }


phoneLayout : List (Element msg)
phoneLayout =
    [ column
        [ width fill
        , paddingXY 30 0
        , spacingXY 0 20
        ]
        [ row [ width fill, height fill, paddingXY 0 50 ]
            [ column [ centerX, width fill ]
                [ row
                    (heading ++ [ centerX ])
                    [ text "FAQ" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 20 ]
            (List.map
                (\( ques, answer ) ->
                    column
                        [ width fill
                        , paddingEach { top = 20, left = 30, right = 30, bottom = 30 }
                        , Border.color colors.white2
                        , Border.rounded 3
                        , Border.shadow
                            { offset = ( 0, 0 )
                            , size = 2
                            , blur = 8
                            , color = colors.gray3
                            }
                        , spacingXY 0 20
                        ]
                        [ paragraph (heading ++ [ padding 10, Font.color colors.orange1, Font.size 20 ]) [ text <| ques ]
                        , paragraph (padding 10 :: Styles.paragraph) [ text <| answer ]
                        ]
                )
                data
            )
        ]
    ]


tabletLayout : List (Element msg)
tabletLayout =
    [ column
        [ width fill
        , paddingXY 50 0
        ]
        [ row [ width fill, height fill, paddingXY 0 50 ]
            [ column [ centerX, width fill, width (minimum 600 shrink) ]
                [ row
                    (heading ++ [ centerX ])
                    [ text "FAQ" ]
                ]
            ]
        , column [ width fill, height fill, spacingXY 30 20, centerX ]
            (List.map
                (\( ques, answer ) ->
                    column
                        [ centerX
                        , width fill
                        , width (maximum 900 fill)
                        , paddingEach { top = 20, left = 30, right = 40, bottom = 30 }
                        , Border.color colors.white2
                        , Border.rounded 3
                        , Border.shadow
                            { offset = ( 0, 0 )
                            , size = 2
                            , blur = 8
                            , color = colors.gray3
                            }
                        , spacingXY 0 20
                        ]
                        [ paragraph (heading ++ [ padding 10, Font.color colors.orange1, Font.size 20 ]) [ text <| ques ]
                        , paragraph (paddingEach { left = 50, top = 10, bottom = 10, right = 0 } :: Styles.paragraph) [ text <| answer ]
                        ]
                )
                data
            )
        ]
    ]


desktopLayout : List (Element msg)
desktopLayout =
    [ column
        [ width fill
        , height fill
        , centerX
        ]
        [ row [ width fill, paddingXY 0 100, spacing 10 ]
            [ column [ width fill, width (minimum 600 shrink), width fill, centerX ]
                [ paragraph
                    heading
                    [ text "FAQ" ]
                ]
            ]
        , row [ width fill, height fill, centerX, spacingXY 20 20, paddingEach { top = 5, bottom = 120, left = 0, right = 0 } ]
            [ column [ spacingXY 0 20, centerX, width fill ]
                (List.map
                    (\( ques, answer ) ->
                        column
                            [ width fill
                            , paddingEach { top = 20, left = 30, right = 40, bottom = 30 }
                            , Border.color colors.white2
                            , Border.rounded 3
                            , Border.shadow
                                { offset = ( 0, 0 )
                                , size = 2
                                , blur = 8
                                , color = colors.gray3
                                }
                            , spacingXY 0 20
                            , width fill
                            , centerX
                            ]
                            [ row (heading ++ [ Font.color colors.orange1, Font.size 20 ]) [ text <| ques ]
                            , paragraph (paddingEach { left = 50, top = 0, bottom = 0, right = 0 } :: Styles.paragraph) [ text <| answer ]
                            ]
                    )
                    data
                )
            ]
        ]
    ]
