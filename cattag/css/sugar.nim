import std/[strutils, sequtils]
export replace
import types, procs
from ../auto/cssProperties import CssProperty

iterator stringPairs[T](a: seq[T]): tuple[key: int, val: string] =
    for i, v in a:
        yield (key: i, val: $v)

proc `:=`*(property: string|CssProperty, values: seq[string]): CssElementProperty =
    ## Sugar constructor for `CssElementProperty`
    result = newCssProperty(property, values)
proc `:=`*(property: string|CssProperty, values: varargs[string]): CssElementProperty =
    ## Sugar constructor for `CssElementProperty`
    result = property := values.toSeq()

proc `:=`*(property: string|CssProperty, values: tuple): CssElementProperty =
    ## Sugar constructor for `CssElementProperty` (slow and janky)
    let
        joinedValues: string = block:
            let j: string = $values
            if likely j.len() > 2: j[1 .. ^2]
            else: ""
        parts: seq[string] = joinedValues.split(", ")
    result = property := parts

template `:=`*(property: string|CssProperty, values: varargs[untyped, `$`]): untyped =
    ## Sugar constructor for `CssElementProperty`
    newCssProperty(property, $values)


proc `{}`*(selector: string, properties: seq[CssElementProperty]): CssElement =
    ## Sugar constructor for `CssElement`
    result = case selector.strip().getSelectorType():
        of selectorAll: newCssAll(properties)
        of selectorClass: newCssClass(selector, properties)
        of selectorId: newCssId(selector, properties)
        of selectorElement: newCssElement(selector, properties)
proc `{}`*(selector: string, properties: varargs[CssElementProperty]): CssElement =
    ## Sugar constructor for `CssElement`
    result = selector{properties.toSeq()}

proc `{}`*(selector: string, elements: seq[CssElement]): CssElement =
    ## Sugar constructor for `CssElement`
    result = case selector.strip().getSelectorType():
        of selectorAll: newCssAll(elements)
        of selectorClass: newCssClass(selector, elements)
        of selectorId: newCssId(selector, elements)
        of selectorElement: newCssElement(selector, elements)
proc `{}`*(selector: string, elements: varargs[CssElement]): CssElement =
    ## Sugar constructor for `CssElement`
    result = selector{elements.toSeq()}
