module Element.WithContext exposing (Attribute, AttributeC, Element, ElementC, column, invariantText, layout, padding, row, spacing, text)

import Element
import Html exposing (Html)


type alias Element msg =
    Element.Element msg


type alias ElementC context msg =
    context -> Element msg


type alias Attribute msg =
    Element.Attribute msg


type alias AttributeC context msg =
    context -> Attribute msg


layout : context -> List (AttributeC context msg) -> ElementC context msg -> Html msg
layout context attrs child =
    Element.layout (List.map ((|>) context) attrs) (child context)


column : List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
column =
    nodeWithChildren Element.column


row : List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
row =
    nodeWithChildren Element.row


nodeWithChildren : (List (Attribute msg) -> List (Element msg) -> Element msg) -> List (AttributeC context msg) -> List (ElementC context msg) -> ElementC context msg
nodeWithChildren f attrs children context =
    f (List.map ((|>) context) attrs) (List.map ((|>) context) children)


invariantText : String -> ElementC context msg
invariantText t _ =
    Element.text t


text : (context -> String) -> (context -> String -> context) -> ElementC context msg
text getter _ context =
    Element.text <| getter context


padding : Int -> AttributeC context msg
padding size _ =
    Element.padding size


spacing : Int -> AttributeC context msg
spacing size _ =
    Element.spacing size
