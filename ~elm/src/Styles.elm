module Styles exposing (ButtonStyle, buttons, colors, heading, textStyles)

import Element
    exposing
        ( Attr
        , Color
        , padding
        , paddingXY
        , rgb255
        , spacing
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


colors : { deepBlue1 : Color, deepBlue2 : Color, deepBlue3 : Color, blue1 : Color, blue2 : Color, blue3 : Color, green1 : Color, green2 : Color, green3 : Color, red1 : Color, red2 : Color, red3 : Color, red4 : Color, white1 : Color, white2 : Color, white3 : Color, gray1 : Color, gray2 : Color, gray3 : Color, black1 : Color, black2 : Color, black3 : Color, creme1 : Color, creme2 : Color, orange1 : Color, orange2 : Color }
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
    , red4 = rgb255 200 0 0
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
    , orange1 = rgb255 255 127 0
    , orange2 = rgb255 245 105 20
    }


heading : List (Attr () msg)
heading =
    [ Font.family
        [ Font.external
            { name = "Noto Sans"
            , url = "/fonts/Noto_Sans/NotoSans-Regular.ttf"
            }
        , Font.sansSerif
        ]
    , Font.size 40
    , spacing 10
    , paddingXY 0 10
    ]


textStyles : List (Attr () msg)
textStyles =
    [ Font.family
        [ Font.external
            { name = "Noto Sans"
            , url = "/fonts/Noto_Sans/NotoSans-Regular.ttf"
            }
        , Font.sansSerif
        ]
    , Font.size 17
    , spacing 10
    ]


type alias ButtonStyle msg =
    { primary : List (Attr () msg)
    , secondary : List (Attr () msg)
    }


buttons : ButtonStyle msg
buttons =
    { primary =
        base
            ++ [ Background.color colors.orange1
               ]
    , secondary =
        base
            ++ [ Background.color colors.gray2
               ]
    }


base : List (Attr () msg)
base =
    [ Border.rounded 3
    , padding 10
    , Font.color colors.white3
    ]
