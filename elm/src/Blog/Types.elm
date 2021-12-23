module Blog.Types exposing (Article, ArticleState(..), Model, Msg(..))

import Browser.Dom exposing (Viewport)
import Device exposing (Device)
import Http


type alias Model =
    { topic : String
    , device : Device
    , article : ArticleState
    , articles : List Article
    , viewing : Maybe String
    }


type ArticleState
    = Loading
    | List (List Article)
    | Loaded Article
    | NotFound


type alias Article =
    { author : String
    , title : String
    , link : String
    , date : String
    , body : String
    , image : String
    , sub : String
    , slug : String
    }


type Msg
    = SetScreenSize Int Int
    | LoadPage Viewport
    | ReceiveBlogData (Result Http.Error String)
