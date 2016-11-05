module Components.View exposing (..)

import Html exposing (Html, div, span, button, text, input, select, option, Attribute)
import Html.Attributes exposing (value, classList)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Models.Store exposing (Store, Grid)
import Actions exposing (Msg(..))
import Components.Debugger exposing (debuggerView)
import Models.Grid exposing (GridObject(..))


view : Store -> Html Msg
view model =
    div []
        [ text "Elm Snake"
        , div [ classList [ ( "grid-container", True ) ] ] [ renderGrid model.grid ]
        , renderButtons
        , debuggerView model
        ]


renderGrid : Grid -> Html Msg
renderGrid grid =
    div [ classList [ ( "grid", True ) ] ] (List.map renderRow grid)


renderRow : List GridObject -> Html Msg
renderRow row =
    div [ classList [ ( "grid-row", True ) ] ] (List.map (\n -> renderCell n) row)


renderCell : GridObject -> Html Msg
renderCell gridObject =
    span [ classList [ ( "grid-cell", True ), ( gridCellClass gridObject, True ) ] ] []


gridCellClass : GridObject -> String
gridCellClass gridObject =
    case gridObject of
        Empty ->
            "cell-empty"

        SnakeCell ->
            "cell-snake"

        Food ->
            "cell-food"


renderButtons : Html Msg
renderButtons =
    div []
        [ button [ onClick StartGame ] [ text "Create Snake" ]
        ]
