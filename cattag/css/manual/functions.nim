import std/[strutils, strformat, sequtils]
import ../[types, cssTypes]

const
    sepSpace: string = " "
    sepComma: string = ", "

proc newCol(value: string): CssColor = CssColor(repr: value)


proc cssAbs*(args: varargs[string]): CssPropertyValue = &"abs({args.toSeq().join(sepSpace)})"

proc cssAcos*(args: varargs[string]): CssPropertyValue = &"acos({args.toSeq().join(sepSpace)})"

proc cssAnchorSize*(args: varargs[string]): CssPropertyValue = &"anchor-size({args.toSeq().join(sepSpace)})" ## Experimental

proc cssAnchor*(args: varargs[string]): CssPropertyValue = &"anchor({args.toSeq().join(sepSpace)})" ## Experimental

proc cssAsin*(args: varargs[string]): CssPropertyValue = &"asin({args.toSeq().join(sepSpace)})"

proc cssAtan*(args: varargs[string]): CssPropertyValue = &"atan({args.toSeq().join(sepSpace)})"

proc cssAtan2*(args: varargs[string]): CssPropertyValue = &"atan2({args.toSeq().join(sepSpace)})"

proc cssAttr*(args: varargs[string]): CssPropertyValue = &"attr({args.toSeq().join(sepSpace)})"

proc cssBlur*(args: varargs[string]): CssPropertyValue = &"blur({args.toSeq().join(sepSpace)})"

# proc cssBrightness*(args: varargs[string]): CssPropertyValue = &"brightness({args.toSeq().join(sepSpace)})"
proc cssBrightness*(amount: float|percentage): CssPropertyValue = &"brightness({amount})"

proc cssCalcSize*(args: varargs[string]): CssPropertyValue = &"calc-size({args.toSeq().join(sepSpace)})" ## Experimental

proc cssCalc*(args: varargs[string]): CssPropertyValue = &"calc({args.toSeq().join(sepSpace)})"

proc cssCircle*(args: varargs[string]): CssPropertyValue = &"circle({args.toSeq().join(sepSpace)})"

proc cssClamp*(args: varargs[string]): CssPropertyValue = &"clamp({args.toSeq().join(sepSpace)})"

proc cssColorMix*(args: varargs[string]): CssPropertyValue = &"color-mix({args.toSeq().join(sepSpace)})"

proc cssColor*(colorSpace: CssColorSpace, a: float|percentage, b: float|percentage, c: float|percentage): CssColor = newCol &"color({colorSpace} {a} {b} {c})"
proc cssColor*(colorSpace: CssColorSpace, a: float|percentage, b: float|percentage, c: float|percentage, A: float|percentage): CssColor = newCol &"color({colorSpace} {a} {b} {c} / {A})"

proc cssConicGradient*(args: varargs[string]): CssGradient = &"conic-gradient({args.toSeq().join(sepSpace)})"

# proc cssContrast*(args: varargs[string]): CssPropertyValue = &"contrast({args.toSeq().join(sepSpace)})"
proc cssContrast*(amount: float|percentage): CssPropertyValue = &"contrast({amount})"

proc cssCos*(number: float|percentage|string): CssPropertyValue = &"cos({number})"

proc cssCounter*(args: varargs[string]): CssPropertyValue = &"counter({args.toSeq().join(sepSpace)})"

proc cssCounters*(args: varargs[string]): CssPropertyValue = &"counters({args.toSeq().join(sepSpace)})"

proc cssCrossFade*(args: varargs[string]): CssPropertyValue = &"cross-fade({args.toSeq().join(sepSpace)})"

proc cssCubicBezier*(x1, y1, x2, y2: float): CssCubicBezierEasingFunction = CssCubicBezierEasingFunction(repr: &"cubic-bezier({x1}, {y1}, {x2}, {y2})")

proc cssDeviceCmyk*(c: float|percentage|string, m: float|percentage|string, y: float|percentage|string, k: float|percentage|string): CssPropertyValue = newCol &"device-cmyk({c} {m} {y} {k})"
proc cssDeviceCmyk*(c: float|percentage|string, m: float|percentage|string, y: float|percentage|string, k: float|percentage|string, a: float|percentage): CssPropertyValue = newCol &"device-cmyk({c} {m} {y} {k} / {a})"
proc cssDeviceCmyk*(c: float|percentage|string, m: float|percentage|string, y: float|percentage|string, k: float|percentage|string, fallback: string): CssPropertyValue = newCol &"device-cmyk({c} {m} {y} {k}, {fallback})"
proc cssDeviceCmyk*(c: float|percentage|string, m: float|percentage|string, y: float|percentage|string, k: float|percentage|string, a: float|percentage, fallback: string): CssPropertyValue = newCol &"device-cmyk({c} {m} {y} {k} / {a}, {fallback})"

proc cssDropShadow*(args: varargs[string]): CssPropertyValue = &"drop-shadow({args.toSeq().join(sepSpace)})"

proc cssElement*(id: string): CssPropertyValue = &"element({id})" ## Experimental

proc cssEllipse*(args: varargs[string]): CssPropertyValue = &"ellipse({args.toSeq().join(sepSpace)})"

proc cssEnv*(value: string): CssPropertyValue = &"env({value})"
proc cssEnv*(value, fallback: string): CssPropertyValue = &"env({value}, {fallback})"

proc cssExp*(number: SomeNumber): CssPropertyValue = &"exp({number})"

proc cssFitContent*(size: string): CssPropertyValue = &"fit-content({size})"

# proc cssGrayscale*(args: varargs[string]): CssPropertyValue = &"grayscale({args.toSeq().join(sepSpace)})"
proc cssGrayscale*(value: float|percentage): CssPropertyValue = &"grayscale({value})"

proc cssHsl*(h: float|percentage|string, s: float|percentage|string, l: float|percentage|string): CssPropertyValue = &"hsl({h} {s} {l})"
proc cssHsl*(h: float|percentage|string, s: float|percentage|string, l: float|percentage|string, a: float|percentage|string): CssPropertyValue = &"hsl({h} {s} {l} / {a})"

proc cssHueRotate*(angle: string|CssAnglePercentage): CssPropertyValue = &"hue-rotate({angle})"

proc cssHwb*(h: float|percentage|string, w: float|percentage|string, b: float|percentage|string): CssPropertyValue = CssColor(repr: &"hwb({h} {w} {b})")
proc cssHwb*(h: float|percentage|string, w: float|percentage|string, b: float|percentage|string, a: float|percentage|string): CssPropertyValue = CssColor(repr: &"hwb({h} {w} {b} / {a})")

proc cssHypot*(args: varargs[string]): CssPropertyValue = &"hypot({args.toSeq().join(sepComma)})" ## TODO: Accepts unit numbers

proc cssImageSet*(args: varargs[string]): CssPropertyValue = &"image-set({args.toSeq().join(sepComma)})"

proc cssImage*(args: varargs[string]): CssPropertyValue = &"image({args.toSeq().join(sepComma)})"

proc cssInset*(args: varargs[string]): CssPropertyValue = &"inset({args.toSeq().join(sepSpace)})"

# proc cssInvert*(args: varargs[string]): CssPropertyValue = &"invert({args.toSeq().join(sepSpace)})"
proc cssInvert*(value: float|percentage): CssPropertyValue = &"invert({value})"

# proc cssLab*(args: varargs[string]): CssPropertyValue = &"lab({args.toSeq().join(sepSpace)})"
proc cssLab*(L: float|percentage|string, a: float|percentage|string, b: float|percentage|string): CssPropertyValue = &"lab({L} {a} {b})"
proc cssLab*(L: float|percentage|string, a: float|percentage|string, b: float|percentage|string, A: float|percentage|string): CssPropertyValue = &"lab({L} {a} {b} / {A})"

proc cssLayer*(name: string): CssPropertyValue = &"layer({name})"

proc cssLch*(l: float|percentage|string, c: float|percentage|string, h: float|percentage|string): CssPropertyValue = &"lch({l} {c} {h})"
proc cssLch*(l: float|percentage|string, c: float|percentage|string, h: float|percentage|string, a: float|percentage|string): CssPropertyValue = &"lch({l} {c} {h} / {a})"

proc cssLightDark*(light, dark: string): CssPropertyValue = &"light-dark({light}, {dark})"

proc cssLinearGradient*(angle: CssAngle, colors: varargs[CssColor]): CssGradient = &"linear-gradient({colors.toSeq().join(sepComma)})"

proc cssLinear*[T: SomeNumber](args: varargs[T]): CssLinearEasingFunction = CssLinearEasingFunction(repr: &"linear({args.toSeq().join(sepComma)})")

proc cssLog*(value: SomeNumber): CssPropertyValue = &"log({value})"
proc cssLog*(value, base: SomeNumber): CssPropertyValue = &"log({value}, {base})"

proc cssMatrix*(a, b, c, d, tx, ty: SomeNumber): CssPropertyValue = &"matrix({a}, {b}, {c}, {d}, {tx}, {ty})"

proc cssMatrix3d*(a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4: SomeNumber): CssPropertyValue = &"matrix3d({a1} {b1} {c1} {d1} {a2} {b2} {c2} {d2} {a3} {b3} {c3} {d3} {a4} {b4} {c4} {d4})"

proc cssMax*(x, y: string|SomeNumber): CssPropertyValue = &"max({x}, {y})"

proc cssMin*(x, y: string|SomeNumber): CssPropertyValue = &"min({x}, {y})"

proc cssMinmax*(x, y: string|SomeNumber): CssPropertyValue = &"minmax({x}, {y})"

proc cssMod*(dividend: string|SomeNumber, divisor: string|SomeNumber): CssPropertyValue = &"mod({dividend}, {divisor})"

proc cssOklab*(L: float|string|percentage, a: float|string|percentage, b: float|string|percentage): CssPropertyValue = &"oklab({L} {a} {b})"
proc cssOklab*(L: float|string|percentage, a: float|string|percentage, b: float|string|percentage, A: float|string|percentage): CssPropertyValue = &"oklab({L} {a} {b} / {A})"

proc cssOklch*(l: float|string|percentage, c: float|string|percentage, h: float|string|percentage): CssPropertyValue = &"oklch({l} {c} {h})"
proc cssOklch*(l: float|string|percentage, c: float|string|percentage, h: float|string|percentage, a: float|string|percentage): CssPropertyValue = &"oklch({l} {c} {h} / {a})"

proc cssOpacity*(value: float|percentage): CssPropertyValue = &"opacity({value})"

proc cssPaint*(worklet: string, args: varargs[string]): CssPropertyValue = &"paint({(@[worklet] & args.toSeq()).join(sepComma)})"

proc cssPaletteMix*(args: varargs[string]): CssPropertyValue = &"palette-mix({args.toSeq().join(sepSpace)})" ## Experimental

proc cssPath*(args: varargs[string]): CssPropertyValue = &"path({args.toSeq().join(sepComma)})"

proc cssPerspective*(value: string|SomeNumber): CssPropertyValue = &"perspective({value})"

proc cssPolygon*[T: SomeNumber](args: varargs[array[2, string|T]]): CssPropertyValue =
    var parts: seq[string]
    for arg in args:
        parts.add &"{arg[0]} {arg[1]}"
    result = &"polygon({parts.join(sepComma)})"

proc cssPow*(base: string|SomeNumber, exponent: string|SomeNumber): CssPropertyValue = &"pow({base}, {exponent})"

proc cssRadialGradient*(args: varargs[string]): CssGradient = &"radial-gradient({args.toSeq().join(sepComma)})"

proc cssRay*(args: varargs[string]): CssPropertyValue = &"ray({args.toSeq().join(sepSpace)})"

proc cssRect*(args: varargs[string]): CssPropertyValue = &"rect({args.toSeq().join(sepSpace)})"

proc cssRem*(dividend: string|SomeNumber, divisor: string|SomeNumber): CssPropertyValue = &"rem({dividend}, {divisor})"

proc cssRepeat*(amount: int, args: varargs[string]): CssPropertyValue = &"repeat({amount}, {args.toSeq().join(sepComma)})"

proc cssRepeatingConicGradient*(args: varargs[string]): CssGradient = &"repeating-conic-gradient({args.toSeq().join(sepComma)})"

proc cssRepeatingLinearGradient*(args: varargs[string]): CssGradient = &"repeating-linear-gradient({args.toSeq().join(sepComma)})"

proc cssRepeatingRadialGradient*(args: varargs[string]): CssGradient = &"repeating-radial-gradient({args.toSeq().join(sepSpace)})"

proc cssRgb*(r: int|float|string|percentage, g: int|float|string|percentage, b: int|float|string|percentage): CssColor = newCol &"rgb({r} {g} {b})"
proc cssRgb*(r: int|float|string|percentage, g: int|float|string|percentage, b: int|float|string|percentage, a: float|string|percentage): CssColor = newCol &"rgb({r} {g} {b} {a})"

proc cssRotate*(value: string|CssAngle): CssPropertyValue = &"rotate({value})"

proc cssRotate3d*(x: string|CssAngle, y: string|CssAngle, z: string|CssAngle, a: string|CssAngle): CssPropertyValue = &"rotate3d({x}, {y}, {z}, {a})"

proc cssRotateX*(value: string|CssAngle): CssPropertyValue = &"rotateX({value})"

proc cssRotateY*(value: string|CssAngle): CssPropertyValue = &"rotateY({value})"

proc cssRotateZ*(value: string|CssAngle): CssPropertyValue = &"rotateZ({value})"

proc cssRound*(args: varargs[string]): CssPropertyValue = &"round({args.toSeq().join(sepComma)})"

proc cssSaturate*(value: string|SomeNumber|percentage): CssPropertyValue = &"saturate({value})"

proc cssScale*(value: SomeNumber): CssPropertyValue = &"scale({value})"
proc cssScale*(x, y: SomeNumber): CssPropertyValue = &"scale({x}, {y})"

proc cssScale3d*(x, y, z: SomeNumber): CssPropertyValue = &"scale3d({x}, {y}, {z})"

proc cssScaleX*(value: SomeNumber): CssPropertyValue = &"scaleX({value})"

proc cssScaleY*(value: SomeNumber): CssPropertyValue = &"scaleY({value})"

proc cssScaleZ*(value: SomeNumber): CssPropertyValue = &"scaleZ({value})"

proc cssScroll*(args: varargs[string]): CssPropertyValue = &"scroll({args.toSeq().join(sepSpace)})" ## Experimental

proc cssSepia*(value: float|percentage): CssPropertyValue = &"sepia({value})"

proc cssShape*(args: varargs[string]): CssPropertyValue = &"shape({args.toSeq().join(sepComma)})"

proc cssSign*(number: string|SomeNumber): CssPropertyValue = &"sign({number})"

proc cssSin*(value: string|SomeNumber|CssAngle): CssPropertyValue = &"sin({value})"

proc cssSkew*(value: string|CssAngle): CssPropertyValue = &"skew({value})"
proc cssSkew*(x: string|CssAngle, y: string|CssAngle): CssPropertyValue = &"skew({x}, {y})"

proc cssSkewX*(value: string|CssAngle): CssPropertyValue = &"skewX({value})"

proc cssSkewY*(value: string|CssAngle): CssPropertyValue = &"skewY({value})"

proc cssSqrt*(value: string|SomeNumber): CssPropertyValue = &"sqrt({value})"

proc cssSteps*(amount: int, position: string): CssStepEasingFunction = CssStepEasingFunction(repr: &"steps({amount}, {position})")

proc cssSymbols*(symbolsType: string, args: varargs[string]): CssPropertyValue =
    var list: seq[string]
    for item in args:
        list.add &"\"{item}\""
    &"symbols({symbolsType}, {list.join(sepSpace)})"

proc cssTan*(angle: string|SomeNumber|CssAngle): CssPropertyValue = &"tan({angle})"

proc cssTranslate*(value: string|SomeNumber|CssAngle): CssPropertyValue = &"translate({value})"

proc cssTranslate3d*(x: string|SomeNumber|CssAngle, y: string|SomeNumber|CssAngle, z: string|SomeNumber|CssAngle): CssPropertyValue = &"translate3d({x}, {y}, {z})"

proc cssTranslateX*(value: string|SomeNumber|CssAngle): CssPropertyValue = &"translateX({value})"

proc cssTranslateY*(value: string|SomeNumber|CssAngle): CssPropertyValue = &"translateY({value})"

proc cssTranslateZ*(value: string|SomeNumber|CssAngle): CssPropertyValue = &"translateZ({value})"

proc cssUrl*(path: string): CssPropertyValue = &"url({path})"

proc cssVar*(variable: string): CssPropertyValue =
    result =
        if variable.startsWith("--"): &"var({variable})"
        else: &"var(--{variable})"

proc cssView*(args: varargs[string]): CssPropertyValue = &"view({args.toSeq().join(sepSpace)})"

proc cssXywh*(args: varargs[string]): CssPropertyValue = &"xywh({args.toSeq().join(sepSpace)})"


proc cssSrc*(src: string): CssSrc = CssSrc(repr: src)
proc cssUrl*(url: string): Cssurl = Cssurl(repr: url)
