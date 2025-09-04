import std/[sequtils]
# proc toSeq[T](a: seq[T]): seq[T] = a ## Override for `toSeq[T](a: varargs[T]): seq[T]`

import ../htmlXml/all
import ../css/all

import
    htmlAttributes,
    htmlElements,
    cssColours,
    cssProperties
export
    htmlAttributes,
    htmlElements,
    cssColours,
    cssProperties


proc `<=>`*(attribute: HtmlAttribute, values: seq[string]): Attribute =
    ## Sugar constructor for `Attribute`
    result = string(attribute) <=> values
proc `<=>`*(attribute: HtmlAttribute, values: varargs[string]): Attribute =
    ## Sugar constructor for `Attribute`
    result = string(attribute) <=> values


const style*: HtmlAttribute = HtmlAttribute "style" ## HtmlAttribute `style` Reference: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes
proc setStyle*(element: var HtmlElement, values: seq[CssElementProperty|CssElement]) =
    ## Sets the HtmlAttribute `style`
    var stringValues: seq[string]
    for value in values:
        stringValues &= $value
    element.attributes.add(attr("style", stringValues))
proc setStyle*(element: HtmlElement, values: seq[CssElementProperty|CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `style`
    result = element
    result.setStyle(values)

proc setStyle*(element: var HtmlElement, values: varargs[CssElementProperty]) =
    ## Sets the HtmlAttribute `style`
    element.setStyle(values.toSeq())
proc setStyle*(element: HtmlElement, values: varargs[CssElementProperty]): HtmlElement =
    ## Sets the HtmlAttribute `style`
    result = element.setStyle(values.toSeq())

proc setStyle*(element: var HtmlElement, values: varargs[CssElement]) =
    ## Sets the HtmlAttribute `style`
    element.setStyle(values.toSeq())
proc setStyle*(element: HtmlElement, values: varargs[CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `style`
    result = element.setStyle(values.toSeq())


proc setClass*(element: var HtmlElement, class: CssElement) =
    ## Sets the HtmlAttribute `class`
    element.setClass(class.selector)
proc setClass*(element: HtmlElement, class: CssElement): HtmlElement =
    ## Sets the HtmlAttribute `class`
    result = element
    result.setClass(class)

proc setClass*(element: var HtmlElement, classes: seq[CssElement]) =
    ## Sets the HtmlAttribute `class`
    for class in classes:
        element.setClass(class)
proc setClass*(element: HtmlElement, classes: seq[CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `class`
    result = element
    result.setClass(classes)

proc setClass*(element: var HtmlElement, classes: varargs[CssElement]) =
    ## Sets the HtmlAttribute `class`
    element.setClass(classes.toSeq())
proc setClass*(element: HtmlElement, classes: varargs[CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `class`
    result = element
    result.setClass(classes.toSeq())
