import std/[sequtils]
import types


template newCssThing(PROC_NAME: untyped, SELECTOR_TYPE: untyped): untyped =
    proc PROC_NAME*(selector: string, properties: seq[CssElementProperty]): CssElement =
        ## Constructs new `CssElement`
        result = CssElement(
            selector: selector,
            selectorType: SELECTOR_TYPE,
            properties: properties
        )
    proc PROC_NAME*(selector: string, properties: varargs[CssElementProperty]): CssElement =
        ## Constructs new `CssElement`
        result = PROC_NAME(selector, properties.toSeq())

newCssThing(newCssElement, selectorElement)
newCssThing(newCssClass, selectorClass)
newCssThing(newCssAll, selectorAll)
newCssThing(newCssId, selectorId)

