import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Char exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model =
  { name : String
  , age: String
  , password : String
  , passwordAgain: String
  }

model : Model
model =
  Model "" "" "" ""

-- UPDATE

type Msg =
  Name String
  | Age String
  | Password String
  | PasswordAgain String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }

    Password password ->
      { model | password = password }

    PasswordAgain passwordAgain ->
      { model | passwordAgain = passwordAgain }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "number", placeholder "Age", onInput Age ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if not ( String.any isDigit model.age ) then
        ("red", "Age must be a digit")
      else if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
      else if String.length model.password < 8 then
        ("red", "Password too short")
      else if correctChars model.password then
        ("red", "The password must contain at least one uppercase letter, one lowercase letter and one number")
      else
        ("green", "OK")
  in
    div [ style [("color", color)] ] [ text message ]

correctChars : String -> Bool
correctChars password =
  not (
    String.any isDigit password
    && String.any isUpper password
    && String.any isLower password
    )
