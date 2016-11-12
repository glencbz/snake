module Subscriptions exposing (subscriptions)

import Char
import Keyboard
import Platform.Sub
import Time
import Actions.Message exposing (Message(TimeStep, NewDirection, Default))
import Config
import Models.GameState exposing (GameState(StateGameStarted))
import Models.Direction exposing (Direction(..))
import Models.Store exposing (Store)
import Port exposing (swipePort)


subscriptions : Store -> Sub Message
subscriptions model =
    Platform.Sub.batch
        [ timeStepSubscription model.gameState
        , keyboardSubscription
        , swipeSubscription
        ]


keyboardSubscription : Sub Message
keyboardSubscription =
    Keyboard.ups
        (\keyCode ->
            if Char.fromCode keyCode == ' ' then
                TimeStep
            else if keyCode == 37 || keyCode == Char.toCode 'H' then
                NewDirection Left
            else if keyCode == 38 || keyCode == Char.toCode 'K' then
                NewDirection Up
            else if keyCode == 39 || keyCode == Char.toCode 'L' then
                NewDirection Right
            else if keyCode == 40 || keyCode == Char.toCode 'J' then
                NewDirection Down
            else
                Default
        )


timeStepSubscription : GameState -> Sub Message
timeStepSubscription gameState =
    case gameState of
        StateGameStarted ->
            Time.every Config.timeInterval (\time -> TimeStep)

        _ ->
            Sub.none


swipeSubscription : Sub Message
swipeSubscription =
    swipePort receiveSwipeString


receiveSwipeString : String -> Message
receiveSwipeString received =
    if received == "up" then
        NewDirection Up
    else if received == "right" then
        NewDirection Right
    else if received == "down" then
        NewDirection Down
    else
        NewDirection Left
