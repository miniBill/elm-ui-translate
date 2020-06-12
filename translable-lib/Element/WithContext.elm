module Element.WithContext exposing (Attribute, AttributeC, Element, ElementC, column, invariantText, layout, padding, row, spacing, text, translationLayout)

import Element
import Element.Input as Input
import Html exposing (Html)


type alias Element msg =
    Element.Element msg


type alias ElementC context msg =
    context -> ( Element msg, Element context )


type alias Attribute msg =
    Element.Attribute msg


type alias AttributeC context msg =
    context -> Attribute msg


layout : context -> List (AttributeC context msg) -> ElementC context msg -> Html msg
layout context attrs child =
    Element.layout (List.map ((|>) context) attrs) (Tuple.first <| child context)


attrsForTranslation : List (AttributeC context msg) -> context -> List (Attribute context)
attrsForTranslation attrs context =
    List.map (\attr -> Element.mapAttribute (\_ -> context) <| attr context) attrs


translationLayout : context -> List (AttributeC context msg) -> ElementC context msg -> Html context
translationLayout context attrs child =
    Element.layout (attrsForTranslation attrs context) (Tuple.second <| child context)


column : List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
column =
    nodeWithChildren Element.column Element.column


row : List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
row =
    nodeWithChildren Element.row Element.row


nodeWithChildren : (List (Attribute msg) -> List (Element msg) -> Element msg) -> (List (Attribute context) -> List (Element context) -> Element context) -> List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
nodeWithChildren f g attrs children context =
    let
        childrenWithContext =
            List.map ((|>) context) children

        normal : Element msg
        normal =
            f (List.map ((|>) context) attrs) (List.map Tuple.first childrenWithContext)

        translating : Element context
        translating =
            g (attrsForTranslation attrs context) (List.map Tuple.second childrenWithContext)
    in
    ( normal, translating )


invariantText : String -> ElementC context msg
invariantText t _ =
    ( Element.text t, Element.text t )


text : (context -> String) -> (context -> String -> context) -> ElementC context msg
text getter setter context =
    ( Element.text <| getter context
    , Input.text [ Element.width <| Element.px 150 ]
        { text = getter <| context
        , onChange = setter context
        , label = Input.labelHidden ""
        , placeholder = Nothing
        }
    )


padding : Int -> AttributeC context msg
padding size _ =
    Element.padding size


spacing : Int -> AttributeC context msg
spacing size _ =
    Element.spacing size
