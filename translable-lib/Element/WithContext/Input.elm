module Element.WithContext.Input exposing (button)

import Element exposing (Attribute)
import Element.Input as Input
import Element.WithContext exposing (AttributeC, ElementC)


attrsForTranslation : List (AttributeC context msg) -> context -> List (Attribute context)
attrsForTranslation attrs context =
    List.map (\attr -> Element.mapAttribute (\_ -> context) <| attr context) attrs


button : List (AttributeC context msg) -> { onPress : Maybe msg, label : ElementC context msg } -> ElementC context msg
button attrs { onPress, label } context =
    let
        ( translatedLabel, translatingLabel ) =
            label context
    in
    ( Input.button (List.map ((|>) context) attrs)
        { onPress = onPress
        , label = translatedLabel
        }
    , Input.button (attrsForTranslation attrs context)
        { onPress = Nothing
        , label = translatingLabel
        }
    )
