import std/[unittest]
import cattag

test "Numbers":
    check "10.0deg" == $10'deg
    check "10.0grad" == $10'grad
    check "10.0rad" == $10'rad
    check "10.0turn" == $10'turn

    check "10.0fr" == $10'fr

    check "10.0Hz" == $10'Hz
    check "10.0kHz" == $10'kHz

    check "10.0cap" == $10'cap
    check "10.0ch" == $10'ch
    check "10.0em" == $10'em
    check "10.0ex" == $10'ex
    check "10.0ic" == $10'ic
    check "10.0lh" == $10'lh
    check "10.0rcap" == $10'rcap
    check "10.0rch" == $10'rch
    check "10.0rem" == $10'rem
    check "10.0rex" == $10'rex
    check "10.0ric" == $10'ric
    check "10.0rlh" == $10'rlh
    check "10.0vh" == $10'vh
    check "10.0vw" == $10'vw
    check "10.0vmax" == $10'vmax
    check "10.0vmin" == $10'vmin
    check "10.0vb" == $10'vb
    check "10.0vi" == $10'vi
    check "10.0cqw" == $10'cqw
    check "10.0cqh" == $10'cqh
    check "10.0cqi" == $10'cqi
    check "10.0cqb" == $10'cqb
    check "10.0cqmin" == $10'cqmin
    check "10.0cqmax" == $10'cqmax
    check "10.0px" == $10'px
    check "10.0cm" == $10'cm
    check "10.0mm" == $10'mm
    check "10.0Q" == $10'Q
    check "10.0pc" == $10'pc
    check "10.0pt" == $10'pt

    check "10.0%" == $10'percent

    check "10.0dpi" == $10'dpi
    check "10.0dpcm" == $10'dpcm
    check "10.0dppx" == $10'dppx
    check "10.0x" == $10'x

    check "10.0s" == $10's
    check "10.0ms" == $10'ms

test "Properties":
    check "background-color: Tomato;" == $(backgroundColor := Tomato)
    check "background-color: Tomato;" == $(backgroundColor := $Tomato)
    check "background-color: Tomato;" == $($backgroundColor := $Tomato)
    check "background-color: Tomato;" == $($backgroundColor := Tomato)

    check "margin: 20.0px 20.0px 10.0px 10.0px;" == $(margin := (20'px, 20'px, 10'px, 10'px))
    check "border: 10.0px Red solid;" == $(border := (10'px, Red, solid))

test "Functions":
    check "rotate(20.0deg)" == $cssRotate(20'deg)
    check "transform: rotate(20.0deg);" == $(transform := cssRotate(20'deg))

    check "blur(4.0px)" == $cssBlur(4'px)
    check "filter: blur(4.0px);" == $(filter := cssBlur(4'px))

    check "color: rgb(10 20 30 / 50.0%);" == $(color := cssRgb(10, 20, 30, 50'percent))
