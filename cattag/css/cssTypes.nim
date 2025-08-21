import std/[strutils]
# Types from https://developer.mozilla.org/en-US/docs/Web/CSS


template dollarRepr(IDENT: typedesc): untyped =
    proc `$`*(obj: IDENT): string =
        ## Stringifies IDENT
        result = obj.repr
template dollarReprWithType(IDENT, TYPE: typedesc, SUFFIX: untyped): untyped =
    proc `$`*(obj: IDENT): string =
        ## Stringifies IDENT
        result = obj.repr & $TYPE
template dollarReprWithType(IDENT, TYPE: typedesc): untyped =
    dollarReprWithType(IDENT, TYPE, IDENT)

template dollarReprWithPreAndSuffix(IDENT: typedesc, PREFIX, SUFFIX: string): untyped =
    proc `$`*(obj: IDENT): string =
        result = PREFIX & obj.repr & SUFFIX

template newSelfSufficientNumber(IDENT: untyped, VALUE_TYPE: typedesc, SUFFIX: string): untyped =
    type IDENT* {.borrow.} = distinct VALUE_TYPE
    proc `'IDENT`*(value: string): IDENT =
        ## New IDENT number
        result = block:
            when VALUE_TYPE is float:
                parseFloat(value).IDENT
            elif VALUE_TYPE is int:
                parseInt(value).IDENT
            else:
                {.fatal: "repr for IDENT (VALUE_TYPE) is not known type".}
                0
    proc `$`*(number: IDENT): string =
        ## Stringifies IDENT number
        result = $number.repr & SUFFIX
template newSelfSufficientNumber(IDENT: untyped, VALUE_TYPE: typedesc): untyped =
    newSelfSufficientNumber(IDENT, VALUE_TYPE, $IDENT)


template newNumberParent(IDENT: untyped, VALUE_TYPE, CHILD_TYPE: typedesc): untyped =
    type IDENT* = object
        value*: VALUE_TYPE
        `type`*: CHILD_TYPE
    proc `$`*(unit: IDENT): string =
        result = $unit.value & $unit.`type`

template newNumberChild(IDENT: untyped, VALUE_TYPE, PARENT_TYPE: typedesc) =
    proc `'IDENT`*(value: string): PARENT_TYPE = PARENT_TYPE(
        value: value.parseFloat(),
        `type`: IDENT
    )

template newRepr(IDENT: untyped, VALUE_TYPE: typedesc): untyped =
    type IDENT* = object
        repr*: VALUE_TYPE
    dollarRepr(IDENT)
template newRepr(IDENT: untyped): untyped =
    newRepr(IDENT, string)



type
    CssPropertyValue* = string # Generic type

type
    CssUrl* = object
        repr*: string
dollarReprWithPreAndSuffix(CssUrl, "url(", ")")

type
    CssSrc* = object
        repr*: string
dollarReprWithPreAndSuffix(CssSrc, "src(", ")")


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
        deg
        grad
        rad
        turn
newNumberParent(CssAngle, float, CssAngleType)
newNumberChild(deg, float, CssAngle)
newNumberChild(grad, float, CssAngle)
newNumberChild(rad, float, CssAngle)
newNumberChild(turn, float, CssAngle)

type
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
        shorterHue = "shorter hue"
        longerHue = "longer hue"
        increasingHue = "increasing hue"
        decreasingHue = "decreasing hue"

newRepr(CssColor)
type
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

newRepr(CssLinearEasingFunction)
newRepr(CssCubicBezierEasingFunction)
newRepr(CssStepEasingFunction)
const
    linear*: CssLinearEasingFunction = CssLinearEasingFunction(repr: "linear")

    ease*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease")
    easeIn*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-in")
    easeOut*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-out")
    easeInOut*: CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: "ease-in-out")

    stepStart*: CssStepEasingFunction = CssStepEasingFunction(repr: "step-start")
    stepEnd*: CssStepEasingFunction = CssStepEasingFunction(repr: "step-end")
dollarRepr(CssLinearEasingFunction)
dollarRepr(CssCubicBezierEasingFunction)
dollarRepr(CssStepEasingFunction)

newRepr(CssFilterFunction)

type
    CssStepPosition* = enum
        jumpStart = "jump-start"
        jumpEnd = "jump-end"
        jumpNone = "jump-none"
        jumpBoth = "jump-both"
        start
        `end` = "end"

newSelfSufficientNumber(fr, float, "fr")
type
    CssFlex* = fr

    CssFrequencyType* = enum
        Hz
        kHz
newNumberParent(CssFrequency, float, CssFrequencyType)
newNumberChild(Hz, float, CssFrequency)
newNumberChild(kHz, float, CssFrequency)

type
    CssGenericFontFamily* = enum
        serif
        sansSerif = "sans-serif"
        monospace
        cursive
        fantasy
        systemUi = "system-ui"
        uiSerif = "ui-serif"
        uiSansSerif = "ui-sans-serif"
        uiMonospace = "ui-monospace"
        uiRounded = "ui-rounded"
        math
        emoji
        fangsong

    CssGradient* = CssPropertyValue

    # CssHexColor

    CssImage* = string|CssUrl|CssSrc|CssGradient

    CssLengthType* = enum
        # Relative length units:
        # - Based on font:
        cap
        ch
        em
        ex
        ic
        lh
        # - Not based on font:
        rcap
        rch
        rem
        rex
        ric
        rlh
        # - Based on viewport:
        vh
        vw
        vmax
        vmin
        vb
        vi
        # - Container query length units:
        cqw
        cqh
        cqi
        cqb
        cqmin
        cqmax

        # Absolute length units:
        px
        cm
        mm
        Q
        pc
        pt
newNumberParent(CssLength, float, CssLengthType)
newNumberChild(cap, float, Csslength)
newNumberChild(ch, float, Csslength)
newNumberChild(em, float, Csslength)
newNumberChild(ex, float, Csslength)
newNumberChild(ic, float, Csslength)
newNumberChild(lh, float, Csslength)
newNumberChild(rcap, float, Csslength)
newNumberChild(rch, float, Csslength)
newNumberChild(rem, float, Csslength)
newNumberChild(rex, float, Csslength)
newNumberChild(ric, float, Csslength)
newNumberChild(rlh, float, Csslength)
newNumberChild(vh, float, Csslength)
newNumberChild(vw, float, Csslength)
newNumberChild(vmax, float, Csslength)
newNumberChild(vmin, float, Csslength)
newNumberChild(vb, float, Csslength)
newNumberChild(vi, float, Csslength)
newNumberChild(cqw, float, Csslength)
newNumberChild(cqh, float, Csslength)
newNumberChild(cqi, float, Csslength)
newNumberChild(cqb, float, Csslength)
newNumberChild(cqmin, float, Csslength)
newNumberChild(cqmax, float, Csslength)
newNumberChild(px, float, Csslength)
newNumberChild(cm, float, Csslength)
newNumberChild(mm, float, Csslength)
newNumberChild(Q, float, Csslength)
newNumberChild(pc, float, Csslength)
newNumberChild(pt, float, Csslength)

type
    CssLineStyle* = enum
        none
        hidden
        dotted
        dashed
        solid
        double
        groove
        ridge
        inset
        outset

    CssOverflowPosition* = enum
        unsafe
        safe

    CssOverflow* = enum
        visible
        hidden
        clip
        scroll
        `auto`

newSelfSufficientNumber(percentage, float, "%")
type percent* = percentage
proc `'percent`*(value: string): percent = `'percentage`(value)
type
    CssPercentage* = percent

    # Experimental: CssPositionArea

    CssPosition* = enum
        left
        center
        right
        top
        bottom

    # CssRatio

    CssRelativeSize* = enum
        smaller
        larger

    CssResolutionType* = enum
        dpi
        dpcm
        dppx
        x # Alias for dppx
newNumberParent(CssResolution, float, CssResolutionType)
newNumberChild(dpi, float, CssResolution)
newNumberChild(dpcm, float, CssResolution)
newNumberChild(dppx, float, CssResolution)
newNumberChild(x, float, CssResolution)

type
    CssSelfPosition* = enum
        center
        start
        `end`
        selfStart = "self-start"
        selfEnd = "self-end"
        flexStart = "flex-start"
        flexEnd = "flex-end"

    CssTextEdge* = enum
        alphabetic
        cap
        ex
        text

    CssTimeType* = enum
        s
        ms
newNumberParent(CssTime, float, CssTimeType)
newNumberChild(s, float, CssTime)
newNumberChild(ms, float, CssTime)

newRepr(CssTransformFunction)



# Combined types:
type
    CssAlphaValue* = SomeNumber|CssPercentage
    CssAnglePercentage* = CssAngle|CssPercentage
    CssColorSpace* = CssPolarColorSpace|CssPolarColorSpace
    CssColourSpace* = CssPolarColourSpace|CssPolarColourSpace
    CssDimension* = CssLength|CssTime|CssFrequency|CssResolution
    CssEasingFunction* = CssLinearEasingFunction|CssCubicBezierEasingFunction|CssStepEasingFunction
    CssFrequencyPercentage* = CssFrequency|CssPercentage
    CssHue* = CssAngle
    CssLengthPercentage* = CssLength|CssPercentage
    CssTimePercentage* = CssTime|CssPercentage
