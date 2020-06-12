module Element.WithContext.Input exposing (button)

import Element.Input as Input
import Element.WithContext exposing (AttributeC, ElementC)


button : List (AttributeC context msg) -> { onPress : Maybe msg, label : ElementC context msg } -> ElementC context msg
button attrs { onPress, label } context =
    Input.button (List.map ((|>) context) attrs)
        { onPress = onPress
        , label = label context
        }
