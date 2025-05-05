import std/[strutils, sequtils]
import types

proc getSelectorType*(selector: string): CssSelectorType =
    ## Gets the `CssSelectorType` corresponding to the selector provided
    let selector: string = selector.strip()
    result = block:
        if selector.startsWith("*"): selectorAll
        elif selector.startsWith("."): selectorClass
        elif selector.startsWith("#"): selectorId
        else: selectorElement


proc newCssAll*(properties: seq[CssElementProperty]): CssElement =
    ## Constructs new `CssElement` with `*` selector
    result = CssElement(
        elementType: typeCssElement,
        selector: "*",
        selectorType: selectorAll,
        properties: properties
    )
proc newCssAll*(properties: varargs[CssElementProperty]): CssElement =
    ## Constructs new `CssElement` with `*` selector
    result = newCssAll(properties.toSeq())

proc newCssAll*(children: seq[CssElement]): CssElement =
    ## Constructs new `CssElement` with `*` selector
    result = CssElement(
        elementType: typeCssElement,
        selector: "*",
        selectorType: selectorAll,
        children: children
    )
proc newCssAll*(children: varargs[CssElement]): CssElement =
    ## Constructs new `CssElement` with `*` selector
    result = newCssAll(children.toSeq())

template newCssThing(PROC_NAME: untyped, SELECTOR_TYPE: untyped): untyped =
    proc PROC_NAME*(selector: string, properties: seq[CssElementProperty]): CssElement =
        ## Constructs new `CssElement`
        result = CssElement(
            elementType: typeCssElement,
            selector: selector.strip(),
            selectorType: SELECTOR_TYPE,
            properties: properties
        )
    proc PROC_NAME*(selector: string, properties: varargs[CssElementProperty]): CssElement =
        ## Constructs new `CssElement`
        result = PROC_NAME(selector, properties.toSeq())

    proc PROC_NAME*(selector: string, children: seq[CssElement]): CssElement =
        ## Constructs new `CssElement`
        result = CssElement(
            elementType: typeCssElement,
            selector: selector.strip(),
            selectorType: SELECTOR_TYPE,
            children: children
        )
    proc PROC_NAME*(selector: string, children: varargs[CssElement]): CssElement =
        ## Constructs new `CssElement`
        result = PROC_NAME(selector, children.toSeq())

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


proc newCssStylesheet*(filename: string): CssStylesheet =
    ## Creates new stylesheet with a file name
    result = CssStylesheet(file: filename)
proc newCssStylesheet*(): CssStylesheet =
    ## Creates new stylesheet with without a file name
    ##
    ## Will raise `IOError` when writing file to disk and no name was provided.
    result = CssStylesheet()


template addChildren(PROC_NAME: untyped): untyped =
    proc PROC_NAME*(stylesheet: var CssStylesheet, children: seq[CssElement]) =
        ## Appends children to stylesheet
        stylesheet.children &= children
    proc PROC_NAME*(stylesheet: CssStylesheet, children: seq[CssElement]): CssStylesheet =
        ## Appends children to stylesheet
        result = stylesheet
        result.children &= children
    proc PROC_NAME*(stylesheet: var CssStylesheet, child: CssElement, children: varargs[CssElement]) =
        ## Appends children to stylesheet
        stylesheet.children &= @[child] & children.toSeq()
    proc PROC_NAME*(stylesheet: CssStylesheet, child: CssElement, children: varargs[CssElement]): CssStylesheet =
        ## Appends children to stylesheet
        result = stylesheet
        result.children &= @[child] & children.toSeq()

addChildren(add)
addChildren(`&=`)
