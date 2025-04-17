import std/[strutils]
# Types from https://developer.mozilla.org/en-US/docs/Web/CSS
type
    CssAbsoluteSize* = enum
        xxSmall = "xx-small"
        xSmall = "x-small"
        small
        medium
        large
        xLarge = "x-large"
        xxLarge = "xx-large"
        xxxLarge = "xxx-large"

    CssAngleType* = enum
        angleDeg = "deg"
        angleGrad = "grad"
        angleRad = "rad"
        angleTurn = "turn"

    CssAngle* = object
        angleType*: CssAngleType
        value*: float

    CssBaselinePosition* = enum
        firstBaseline = "first baseline"
        lastBaseline = "last baseline"

    # CssBasicShape

    CssBlendMode* = enum
        normal
        multiply
        screen
        overlay
        darken
        lighten
        colorDodge = "color-dodge"
        colorBurn = "color-burn"
        hardLight = "hard-light"
        softLight = "soft-light"
        difference
        exclusion
        hue
        saturation
        color
        luminosity

    CssBoxEdge* = enum
        contentBox = "content-box"
        paddingBox = "padding-box"
        borderBox = "border-box"
        marginBox = "margin-box"
        fillBox = "fill-box"
        strokeBox = "stroke-box"
        viewBox = "view-box"

    CssCalcKeyword* = enum
        e
        pi
        positiveInfinity = "infinity"
        negativeInfinity = "-infinity"
        NaN

    CssRectangularColorSpace* = enum
        srgb
        srgbLinear = "srgb-linear"
        displayP3 = "display-p3"
        a98Rgb = "a98-rgb"
        prophotoRgb = "prophoto-rgb"
        rec2020
        lab
        oklab
        xyz
        xyzD50 = "xyz-d50"
        xyzD65 = "xyz-d65"
    CssRectangularColourSpace* = CssRectangularColorSpace

    CssPolarColorSpace* = enum
        hsl
        hwb
        lch
        oklch
    CssPolarColourSpace* = CssPolarColorSpace

    CssHueInterpolationMethod* = enum
        shorter
        longer
        increasing
        decreasing

    CssColor* = object
        repr*: string
    CssColour* = CssColor

    CssContentDistribution* = enum
        spaceBetween = "space-between"
        spaceAround = "space-around"
        spaceEvenly = "space-evenly"
        stretch

    CssContentPosition* = enum
        center
        start
        `end` = "end"
        flexStart = "flex-start"
        flexEnd = "flex-end"

    # CssCustomIdent
    # CssDashedIdent

    CssDisplayBox* = enum
        contents
        none

    CssDisplayInside* = enum
        flow
        flowRoot = "flow-root"
        table
        flex
        grid
        ruby

    CssDisplayInternal* = enum
        tableRowGroup = "table-row-group"
        tableHeaderGroup = "table-header-group"
        tableFooterGroup = "table-footer-group"
        tableRow = "table-row"
        tableCell = "table-cell"
        tableColumnGroup = "table-column-group"
        tableColumn = "table-column"
        tableCaption = "table-caption"
        rubyBase = "ruby-base"
        rubyText = "ruby-text"
        rubyBaseContainer = "ruby-base-container"
        rubyTextContainer = "ruby-text-container"

    CssDisplayLegacy* = enum
        inlineBlock = "inline-block"
        inlineTable = "inline-table"
        inlineFlex = "inline-flex"
        inlineGrid = "inline-grid"

    # CssDisplayListItem

    CssDisplayOutside* = enum
        `block` = "block"
        inline

    CssLinearEasingFunction* = object
        repr*: string

    CssCubicBezierEasingFunction* = object
        repr*: string

    CssStepEasingFunction* = object
        repr*: string

    CssStepPosition* = enum
        jumpStart = "jump-start"
        jumpEnd = "jump-end"
        jumpNone = "jump-none"
        jumpBoth = "jump-both"
        start
        `end` = "end"



const
    linear*: CssLinearEasingFunction = CssLinearEasingFunction(repr: "linear")

    ease*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease")
    easeIn*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-in")
    easeOut*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-out")
    easeInOut*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-in-out")

    stepStart*: CssStepEasingFunction = CssStepEasingFunction(repr: "step-start")
    stepEnd*: CssStepEasingFunction = CssStepEasingFunction(repr: "step-end")

template dollarRepr(IDENT: typedesc): untyped =
    proc `$`*(function: IDENT): string =
        ## Stringifies IDENT
        result = function.repr

template newNumber(IDENT: untyped, REPR: typedesc): untyped =
    type IDENT* {.borrow.} = distinct REPR
    proc `'IDENT`*(value: string): IDENT =
        ## New IDENT number
        result = block:
            when REPR is float:
                parseFloat(value).IDENT
            elif REPR is int:
                parseInt(value).IDENT
            else:
                {.warning: "".}
                0
    proc `$`*(number: IDENT): string =
        ## Stringifies IDENT number
        result = $number.REPR & $IDENT
template newNumber(IDENT: untyped, REPR: typedesc, SUFFIX: untyped): untyped =
    type IDENT* {.borrow.} = distinct REPR
    proc `'IDENT`*(value: string): IDENT =
        ## New IDENT number
        result = block:
            when REPR is float:
                parseFloat(value).IDENT
            elif REPR is int:
                parseInt(value).IDENT
            else:
                {.fatal: "repr for IDENT (REPR) is not known type".}
                0
    proc `$`*(number: IDENT): string =
        ## Stringifies IDENT number
        result = $number.REPR & "SUFFIX"

newNumber(fr, float)
newNumber(percentage, float, `%`)

type
    CssAlphaValue* = SomeNumber|percentage
    CssAnglePercentage* = CssAngle|percentage
    CssColorSpace* = CssPolarColorSpace|CssPolarColorSpace
    CssColourSpace* = CssPolarColourSpace|CssPolarColourSpace
    #CssDimension* = CssLength|CssTime|CssFrequency|CssResolution
    CssEasingFunction* = CssLinearEasingFunction|CssCubicBezierEasingFunction|CssStepEasingFunction
    CssFlex* = fr
    #CssFrequencyPercentage* = CssFrequency|percentage

proc `$`*(angle: CssAngle): string =
    result = $angle.value & $angle.angleType

proc `$`*(color: CssColor): string =
    result = color.repr

dollarRepr(CssLinearEasingFunction)
dollarRepr(CssCubicBezierEasingFunction)
dollarRepr(CssStepEasingFunction)
#dollarRepr(CssFilterFunction)
