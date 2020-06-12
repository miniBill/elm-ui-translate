module TranslatorUI exposing (main)

import Browser
import Element.WithContext as Element
import Html as H exposing (Html)
import Html.Events as E
import Main exposing (L10N, update)


type alias Model =
    { main : Main.Model
    , translating : Bool
    , en : L10N
    , it : L10N
    }


type Msg
    = MainMsg Main.Msg
    | En L10N
    | It L10N
    | Translating Bool


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    { main = Main.init
    , translating = False
    , en = Main.enL10N
    , it = Main.itL10N
    }


view : Model -> Html Msg
view ({ translating, en, it } as model) =
    let
        ( l10n, toMsg ) =
            case model.main.lang of
                Main.En ->
                    ( en, En )

                Main.It ->
                    ( it, It )
    in
    H.div []
        [ H.button [ E.onClick <| Translating <| not model.translating ]
            [ H.text <|
                if translating then
                    "Done"

                else
                    "Edit translation"
            ]
        , if translating then
            H.map toMsg <|
                Element.translationLayout l10n [] <|
                    Main.innerView model.main

          else
            H.map MainMsg <|
                Element.layout l10n [] <|
                    Main.innerView model.main
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        MainMsg submsg ->
            { model | main = Main.update submsg model.main }

        En en ->
            { model | en = en }

        It it ->
            { model | it = it }

        Translating translating ->
            { model | translating = translating }
