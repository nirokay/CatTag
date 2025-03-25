import std/[sequtils]
import types


template newCssThing(PROC_NAME: untyped, SELECTOR_TYPE: untyped): untyped =
    proc PROC_NAME*(selector: string, properties: seq[CssElementProperty]): CssElement =
        ## Constructs new `CssElement`
        result = CssElement(
            elementType: typeCssElement,
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


proc newCssComment*(lines: seq[string]): CssElement =
    ## Constructs new `CssElement` comment
    result = CssElement(
        elementType: typeCssComment,
        comment: lines
    )
proc newCssComment*(lines: varargs[string]): CssElement =
    ## Constructs new `CssElement` comment
    result = newCssComment(lines.toSeq())


proc newCssProperty*(property: string, values: seq[string]): CssElementProperty =
    ## Constructs new property
    result = CssElementProperty(property: property, values: values)
proc newCssProperty*(property: string, values: varargs[string]): CssElementProperty =
    ## Constructs new property
    result = CssElementProperty(property: property, values: values.toSeq())
