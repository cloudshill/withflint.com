module Blog.View exposing (view)

import Blog.Types exposing (Article, ArticleState(..), Model, Msg)
import Element
    exposing
        ( Element
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
        , mouseOver
        , newTabLink
        , padding
        , paddingEach
        , paddingXY
        , paragraph
        , px
        , row
        , spacing
        , text
        , textColumn
        , width
        )
import Element.Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Element.Region
import Html
import Html.Attributes
import Layout exposing (layout)
import Markdown.Block as Block exposing (ListItem(..), Task(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Router.Routes as R
import Styles exposing (colors)


view : Model -> Element Msg
view model =
    layout model.device
        { phone = blogPhoneView model.article
        , tablet = blogView model.article
        , desktop = blogView model.article
        }


blogView : ArticleState -> List (Element Msg)
blogView article =
    case article of
        Loading ->
            [ text "Loading..."
            ]

        NotFound ->
            [ oops
            ]

        List articles ->
            [ articles
                |> List.indexedMap (hr articleSummaryView)
                |> List.map (row [ width fill, centerX, alignTop ])
                |> column [ width fill, centerX, alignTop, width <| maximum 850 fill, paddingXY 80 40, spacing 80 ]
            ]

        Loaded article_ ->
            article_ |> articleView


hr : (c -> List (Element msg)) -> number -> c -> List (Element msg)
hr f index article =
    [ column [ width fill ]
        ((if index == 0 then
            []

          else
            [ el
                [ width fill
                , centerX
                , Border.widthEach
                    { bottom = 0
                    , left = 0
                    , right = 0
                    , top = 1
                    }
                , paddingEach
                    { bottom = 15
                    , left = 0
                    , right = 0
                    , top = 0
                    }
                , Border.color
                    colors.white1
                ]
                (text "")
            ]
         )
            ++ f article
        )
    ]


articleSummaryView : Article -> List (Element msg)
articleSummaryView article =
    [ link [ width fill, centerX ]
        { url = R.toPath <| R.Blog article.slug
        , label =
            column
                [ spacing 30, centerX ]
                [ paragraph [ Styles.headFont, Font.size 40, Font.bold, mouseOver [ Font.color colors.orange2 ] ] [ text article.title ]
                , row
                    [ spacing 5
                    , alignTop
                    , width (fill |> maximum 100)
                    , Font.size 14
                    ]
                    [ image [ Border.rounded 25, centerY, width (px 28), height (px 28) ] { src = article.avatar, description = article.author }
                    , text article.author
                    , el [] (text "·")
                    , el [] (text article.bio)
                    , el [] (text "·")
                    , el [ Font.color colors.gray2 ] (text article.date)
                    ]
                , column
                    (Styles.paragraph
                        ++ [ centerX
                           , Font.size 20
                           , spacing 40
                           ]
                    )
                    [ paragraph [ width fill ] [ text article.sub ] ]
                ]
        }
    ]


articleView : Article -> List (Element msg)
articleView article =
    [ case markdownView article.body of
        Ok rendered ->
            column
                [ padding 80, width <| maximum 850 fill, spacing 40, centerX ]
                [ paragraph [ Styles.headFont, Font.bold, Font.size 46 ] [ text article.title ]
                , row
                    [ spacing 5
                    , alignTop
                    , width (fill |> maximum 100)
                    , Font.size 14
                    ]
                    [ newTabLink
                        []
                        { url = article.link
                        , label = image [ Border.rounded 25, centerY, width (px 28), height (px 28) ] { src = article.avatar, description = article.author }
                        }
                    , newTabLink
                        [ Font.underline ]
                        { url = article.link
                        , label = text article.author
                        }
                    , el [] (text "·")
                    , el [] (text article.bio)
                    , el [] (text "·")
                    , el [ Font.color colors.gray2 ] (text article.date)
                    ]
                , column
                    (Styles.paragraph
                        ++ [ centerX
                           , Font.size 20
                           , spacing 20
                           ]
                    )
                    rendered
                ]

        Err _ ->
            oops
    ]


blogPhoneView : ArticleState -> List (Element Msg)
blogPhoneView article =
    case article of
        Loading ->
            [ text "Loading..."
            ]

        NotFound ->
            [ text "404 Oops! We can't find that."
            ]

        List articles ->
            [ articles
                |> List.indexedMap (hr articlePhoneSummaryView)
                |> List.map (row [ width fill, centerX, alignTop ])
                |> column
                    [ width fill
                    , centerX
                    , alignTop
                    , paddingXY 20 20
                    , spacing 10
                    ]
            ]

        Loaded article_ ->
            article_ |> articlePhoneView


articlePhoneSummaryView : Article -> List (Element Msg)
articlePhoneSummaryView article =
    let
        go : Element msg -> Element msg
        go ele =
            link [ width fill, mouseOver [ Font.color colors.orange2 ] ]
                { url = R.toPath <| R.Blog article.slug
                , label = ele
                }
    in
    [ column
        [ width fill
        , spacing 30
        , centerX
        ]
        [ paragraph [ Styles.headFont, Font.size 24, Font.bold, width fill ] [ go <| text article.title ]
        , go <|
            row
                [ spacing 5
                , alignTop
                , Font.size 14
                , width fill
                ]
                [ image [ Border.rounded 25, centerY, width (px 28), height (px 28) ] { src = article.avatar, description = article.author }
                , text article.author
                , el [] (text "·")
                , el [] (text article.bio)
                , el [] (text "·")
                , el [ Font.color colors.gray2 ] (text article.date)
                ]
        , go <|
            textColumn
                (Styles.paragraph
                    ++ [ width fill
                       , centerX
                       , Font.size 18
                       ]
                )
                [ paragraph [ width fill ] [ text article.sub ] ]
        ]
    ]


articlePhoneView : Article -> List (Element msg)
articlePhoneView article_ =
    [ case markdownView article_.body of
        Ok rendered ->
            column
                [ paddingXY 20 20
                , width fill
                , spacing 30
                ]
                [ paragraph [ Styles.headFont, Font.bold, Font.size 32 ] [ text article_.title ]
                , row
                    [ spacing 5
                    , alignTop
                    , width (fill |> maximum 100)
                    , Font.size 14
                    ]
                    [ newTabLink
                        []
                        { url = article_.link
                        , label = image [ Border.rounded 25, centerY, width (px 28), height (px 28) ] { src = article_.avatar, description = article_.author }
                        }
                    , newTabLink
                        [ Font.underline ]
                        { url = article_.link
                        , label = text article_.author
                        }
                    , el [] (text "·")
                    , el [] (text article_.bio)
                    , el [] (text "·")
                    , el [ Font.color colors.gray2 ] (text article_.date)
                    ]
                , column
                    (Styles.paragraph
                        ++ [ width fill
                           , centerX
                           , Font.size 18
                           , spacing 30
                           ]
                    )
                    rendered
                ]

        Err _ ->
            oops
    ]


markdownView : String -> Result String (List (Element msg))
markdownView markdown =
    markdown
        |> Markdown.Parser.parse
        |> Result.mapError (\error -> error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")
        |> Result.andThen (Markdown.Renderer.render elmUiRenderer)


elmUiRenderer : Markdown.Renderer.Renderer (Element msg)
elmUiRenderer =
    { heading = heading
    , paragraph = Element.paragraph Styles.paragraph
    , thematicBreak = Element.none
    , text = text
    , strong = \content -> Element.row [ Font.bold ] content
    , emphasis = \content -> Element.row [ Font.italic ] content
    , strikethrough = \content -> Element.row [ Font.strike ] content
    , codeSpan = code
    , link =
        \{ destination } body ->
            Element.newTabLink
                [ Element.htmlAttribute (Html.Attributes.style "display" "inline-flex") ]
                { url = destination
                , label =
                    Element.paragraph
                        Styles.link
                        body
                }
    , hardLineBreak = Html.br [] [] |> Element.html
    , image =
        \image ->
            case image.title of
                Just title ->
                    Element.image [ Element.width Element.fill ] { src = image.src, description = title }

                Nothing ->
                    Element.image [ Element.width Element.fill ] { src = image.src, description = image.alt }
    , blockQuote =
        \children ->
            Element.column
                [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 10 }
                , padding 10
                , Border.color (Element.rgb255 145 145 145)
                , Element.Background.color (Element.rgb255 245 245 245)
                ]
                children
    , unorderedList =
        \items ->
            Element.column [ Element.spacing 15 ]
                (items
                    |> List.map
                        (\(ListItem task children) ->
                            Element.row [ Element.spacing 5 ]
                                [ Element.row
                                    [ Element.alignTop ]
                                    ((case task of
                                        IncompleteTask ->
                                            Element.Input.defaultCheckbox False

                                        CompletedTask ->
                                            Element.Input.defaultCheckbox True

                                        NoTask ->
                                            Element.text "•"
                                     )
                                        :: Element.text " "
                                        :: children
                                    )
                                ]
                        )
                )
    , orderedList =
        \startingIndex items ->
            Element.column [ Element.spacing 15 ]
                (items
                    |> List.indexedMap
                        (\index itemBlocks ->
                            Element.row [ Element.spacing 5 ]
                                [ Element.row [ Element.alignTop ]
                                    (Element.text (String.fromInt (index + startingIndex) ++ " ") :: itemBlocks)
                                ]
                        )
                )
    , codeBlock = codeBlock
    , html = Markdown.Html.oneOf []
    , table = Element.column []
    , tableHeader = Element.column []
    , tableBody = Element.column []
    , tableRow = Element.row []
    , tableHeaderCell =
        \_ children ->
            Element.paragraph [] children
    , tableCell =
        \_ children ->
            Element.paragraph [] children
    }


code : String -> Element msg
code snippet =
    Element.el
        [ Element.Background.color
            (Element.rgba 0 0 0 0.04)
        , Border.rounded 2
        , Element.paddingXY 5 3
        , Styles.codeFont
        ]
        (Element.text snippet)


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    Element.el
        [ Element.Background.color (Element.rgba 0 0 0 0.03)
        , Element.htmlAttribute (Html.Attributes.style "white-space" "pre")
        , Element.padding 20
        , Styles.codeFont
        ]
        (Element.text details.body)


heading : { level : Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    Element.paragraph
        [ Font.color colors.black1
        , Font.size
            (case level of
                Block.H1 ->
                    36

                Block.H2 ->
                    24

                _ ->
                    20
            )
        , Font.regular
        , Element.Region.heading (Block.headingLevelToInt level)
        , Element.htmlAttribute
            (Html.Attributes.attribute "name" (rawTextToId rawText))
        , Element.htmlAttribute
            (Html.Attributes.id (rawTextToId rawText))
        , Styles.headFont
        , paddingEach
            { bottom = 0
            , left = 0
            , right = 0
            , top = 20
            }
        , Font.letterSpacing 1
        ]
        children


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower


oops : Element msg
oops =
    text "Oops! We can't find that."
