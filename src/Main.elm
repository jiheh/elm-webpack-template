module Main exposing (main)

import Browser as Browser exposing (Document)
import Html exposing (Html, a, button, div, h1, table, td, text, th, tr)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Value)
import Restaurant exposing (Restaurant)
import Result



-- Model


type alias Model =
    { restaurants : List Restaurant }


initModel : Model
initModel =
    { restaurants = [] }



-- Update


type Msg
    = NoOp
    | GetRestaurants
    | UpdateRestaurants (Result Http.Error (List Restaurant))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetRestaurants ->
            ( model, Restaurant.getRestaurants |> Http.send UpdateRestaurants )

        UpdateRestaurants result ->
            case result of
                Result.Ok restaurants ->
                    ( { model | restaurants = restaurants }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )



-- View


view : Model -> Document Msg
view model =
    { title = "Elm Webpack Template"
    , body = renderBody model
    }


renderBody : Model -> List (Html Msg)
renderBody model =
    [ h1 [] [ text "Random NYC Restaurants" ]
    , button [ onClick GetRestaurants ] [ text "Click ME!" ]
    , renderRestaurants model.restaurants
    ]


renderRestaurants : List Restaurant -> Html Msg
renderRestaurants restaurants =
    if List.isEmpty restaurants then
        text ""

    else
        let
            rows =
                restaurants
                    |> List.map (\r -> renderRestaurant r)
                    |> List.append [ tableHeaderView ]
        in
        table [] rows


renderRestaurant : Restaurant -> Html Msg
renderRestaurant restaurant =
    tr []
        [ td [] [ text restaurant.name ]
        , td [] [ text restaurant.address ]
        , td [] [ a [ href restaurant.url ] [ text "Click Here" ] ]
        ]


tableHeaderView : Html Msg
tableHeaderView =
    tr []
        [ th [] [ text "Name" ]
        , th [] [ text "Address" ]
        , th [] [ text "Website" ]
        ]



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


init : Value -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )


main : Program Value Model Msg
main =
    -- Note, for more complex applications, Browser.application is recommended.
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
