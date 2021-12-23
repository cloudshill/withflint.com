module Blog.Update exposing (init, loadArticle, update)

import Blog.Types exposing (Article, ArticleState(..), Model, Msg(..))
import Browser.Dom
import Device exposing (Device(..), classify)
import Http
import Json.Decode as D
import Json.Decode.Extra exposing (andMap)
import Return exposing (Return, return)
import Task
import Types


init : Maybe String -> Return Msg Model
init article =
    return
        { topic = ""
        , device = NotSet
        , articles = []
        , article = Loading
        , viewing = article
        }
        (Task.perform LoadPage Browser.Dom.getViewport)


update : Types.Msg -> Model -> Return Msg Model
update msgFor model =
    case msgFor of
        Types.MsgForBlog msg ->
            updateBlog msg model

        _ ->
            return model Cmd.none


updateBlog : Msg -> Model -> Return Msg Model
updateBlog msg model =
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
                    { url = "/articles"
                    , expect = Http.expectString ReceiveBlogData
                    }
                )

        ReceiveBlogData result ->
            case result of
                Ok raw ->
                    case D.decodeString (D.list decode) raw of
                        Ok articles ->
                            case model.viewing of
                                Nothing ->
                                    return { model | article = List articles, articles = articles } Cmd.none

                                Just viewing ->
                                    return { model | article = chooseArticle articles viewing, articles = articles } Cmd.none

                        Err _ ->
                            return { model | article = NotFound } Cmd.none

                Err _ ->
                    return { model | article = NotFound } Cmd.none

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


decode : D.Decoder Article
decode =
    D.succeed Article
        |> andMap (D.field "author" D.string)
        |> andMap (D.field "title" D.string)
        |> andMap (D.field "link" D.string)
        |> andMap (D.field "date" D.string)
        |> andMap (D.field "body" D.string)
        |> andMap (D.field "image" D.string)
        |> andMap (D.field "sub" D.string)
        |> andMap (D.field "slug" D.string)


loadArticle : Model -> String -> Model
loadArticle model viewing =
    if viewing == "" then
        { model | article = List model.articles, viewing = Nothing }

    else
        { model | article = chooseArticle model.articles viewing, viewing = Just viewing }


chooseArticle : List Article -> String -> ArticleState
chooseArticle articles viewing =
    articles
        |> List.foldr
            (\article_ selected ->
                case selected of
                    Loaded _ ->
                        selected

                    _ ->
                        if article_.slug == viewing then
                            Loaded article_

                        else
                            NotFound
            )
            NotFound
