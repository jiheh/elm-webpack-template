module Restaurant exposing (Restaurant, getRestaurants)

import Http
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (required)


type alias Restaurant =
    { id : Int
    , name : String
    , address : String
    , url : String
    }


getRestaurants : Http.Request (List Restaurant)
getRestaurants =
    Http.get "https://opentable.herokuapp.com/api/restaurants?per_page=100&city=New%20York" restaurantsDecoder


restaurantsDecoder : Decoder (List Restaurant)
restaurantsDecoder =
    JD.field "restaurants" (JD.list restaurantDecoder)


restaurantDecoder : Decoder Restaurant
restaurantDecoder =
    JD.succeed Restaurant
        |> required "id" JD.int
        |> required "name" JD.string
        |> required "address" JD.string
        |> required "reserve_url" JD.string
