import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Task
import Http
import Json.Decode as Json

main =
  App.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  }

-- INIT

init : (Model, Cmd Msg)
init =
  (Model "cats" "waiting.gif", Cmd.none)


-- UPDATE

type Msg =
  MorePlease
  | FetchSucceed String
  | FetchError Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGiff model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchError error ->
      (model, Cmd.none)


getRandomGiff: String -> Cmd Msg
getRandomGiff topic =
  let url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in Task.perform FetchError FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl: Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , button [onClick MorePlease] [text "more please"]
    , br [] []
    , img [src model.gifUrl] []
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
