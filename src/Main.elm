module Main exposing (L10N, Lang(..), Model, Msg, enL10N, init, innerView, itL10N, main, update, view)

import Browser
import Element.WithContext as Element
import Element.WithContext.Input as Input
import Html


{-| Here we keep the current language in the Model.
You could also create different applications, if you don't need runtime switching and would like smaller assets.
-}
type alias Model =
    { count : Int
    , lang : Lang
    }


{-| The key idea, is replacing elm-ui's `Element` with a function from a context (here, the localized strings) to `Element`.
`ElementC context msg` is (in production) an alias for `context -> Element msg`.
-}
type alias Element msg =
    Element.ElementC L10N msg


{-| The `layout` call is the same as elm-ui, with the addition of the context parameter that will get passed below
-}
view : Model -> Html.Html Msg
view model =
    let
        l10n =
            case model.lang of
                En ->
                    enL10N

                It ->
                    itL10N
    in
    Element.layout l10n [] <| innerView model


{-| The view is mostly API-compatible with elm-ui.
The only difference is using `text/invariantText` for text, depending on wether you need the context or not.
The setter is needed for the translation UI, it's ignored by the normal UI
and will hopefully get tree shaken.
-}
innerView : Model -> Element Msg
innerView model =
    Element.column [ Element.spacing 10, Element.padding 10 ]
        [ Element.invariantText <| String.fromInt model.count
        , Element.row [ Element.spacing 10 ]
            [ Input.button []
                { onPress = Just Inc
                , label = Element.text .inc (\l10n inc -> { l10n | inc = inc })
                }
            , Input.button []
                { onPress = Just Dec
                , label = Element.text .dec (\l10n dec -> { l10n | dec = dec })
                }
            ]
        , case model.lang of
            En ->
                Input.button []
                    { onPress = Just <| Lang It
                    , label = Element.invariantText "🇮🇹 Italiano"
                    }

            It ->
                Input.button []
                    { onPress = Just <| Lang En
                    , label = Element.invariantText "🇺🇸/🇬🇧 English"
                    }
        ]



---------------
-- Languages --
---------------


type alias L10N =
    { inc : String
    , dec : String
    }


enL10N : L10N
enL10N =
    { inc = "Increment"
    , dec = "Decrement"
    }


itL10N : L10N
itL10N =
    { inc = "Incrementa"
    , dec = "Decrementa"
    }


type Lang
    = En
    | It



--------------------------
-- main/init/Msg/update --
--------------------------
--
-- Nothing to see here, standard TEA


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    { count = 0
    , lang = En
    }


type Msg
    = Inc
    | Dec
    | Lang Lang


update : Msg -> Model -> Model
update msg model =
    case msg of
        Inc ->
            { model | count = model.count + 1 }

        Dec ->
            { model | count = model.count - 1 }

        Lang lang ->
            { model | lang = lang }
