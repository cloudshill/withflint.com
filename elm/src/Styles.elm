module Styles exposing (buttons, colors, heading, textStyles)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


colors =
    { deepBlue1 = rgb255 1 55 89
    , deepBlue2 = rgb255 9 68 105
    , deepBlue3 = rgb255 11 87 137
    , blue1 = rgb255 16 121 153
    , blue2 = rgb255 24 147 189
    , blue3 = rgb255 29 170 217
    , green1 = rgb255 71 159 108
    , green2 = rgb255 88 190 129
    , green3 = rgb255 99 215 145
    , red1 = rgb255 106 38 41
    , red2 = rgb255 146 54 55
    , red3 = rgb255 195 58 66
    , white1 = rgb255 223 223 223
    , white2 = rgb255 248 248 248
    , white3 = rgb255 255 255 255
    , gray1 = rgb255 90 90 90
    , gray2 = rgb255 130 130 130
    , gray3 = rgb255 204 204 204
    , black1 = rgb255 29 30 35
    , black2 = rgb255 45 45 45
    , black3 = rgb255 51 51 50
    , creme1 = rgb255 251 247 210
    , creme2 = rgb255 253 252 234
    , orange = rgb255 255 127 0
    }


heading =
    [ Font.family
        [ Font.external
            { name = "Montserrat"
            , url = "https://fonts.googleapis.com/css2?family=Montserrat:wght@200&family=Noto+Sans+Display:wght@200;400;500&family=Open+Sans:wght@300&display=swap"
            }
        , Font.sansSerif
        ]
    , Font.size 40
    , Font.bold
    , spacing 10
    , paddingXY 0 10
    ]


textStyles =
    [ Font.family
        [ Font.external
            { name = "Montserrat"
            , url = "https://fonts.googleapis.com/css2?family=Montserrat:wght@200;400;600;800;900&family=Noto+Sans+Display:wght@200;400;500&family=Open+Sans:wght@300&display=swap"
            }
        , Font.sansSerif
        ]
    , Font.bold
    , Font.size 17
    , spacing 10
    ]


buttons =
    { primary =
        base
            ++ [ Background.color colors.orange
               ]
    , secondary =
        base
            ++ [ Background.color colors.gray2
               ]
    }


base =
    [ Border.rounded 3
    , padding 10
    , Font.color colors.white3
    ]
