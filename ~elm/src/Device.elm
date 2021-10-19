module Device exposing (classify)

import Element exposing (Device, DeviceClass(..), Orientation(..))


classify : { window | height : Int, width : Int } -> Device
classify window =
    { class =
        if window.width < 700 then
            Phone

        else if window.width <= 1200 then
            Tablet

        else if window.width > 1200 && window.width <= 1920 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }
