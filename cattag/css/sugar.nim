import std/[strutils, sequtils]
import types, procs


proc `:=`*(property: string, values: seq[string]): CssElementProperty =
    ## Sugar constructor for `CssElementProperty`
    result = newCssProperty(property, values)
proc `:=`*(property: string, values: varargs[string]): CssElementProperty =
    ## Sugar constructor for `CssElementProperty`
    result = property := values.toSeq()


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
