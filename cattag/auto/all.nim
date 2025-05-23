import std/[sequtils]
proc toSeq[T](a: seq[T]): seq[T] = a ## Override for `toSeq[T](a: varargs[T]): seq[T]`

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


const style*: HtmlAttribute = "style" ## HtmlAttribute `style` Notes: [Global] Reference: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/style
proc setStyle*(element: var HtmlElement, values: seq[CssElementProperty]|varargs[CssElement]) =
    ## Sets the HtmlAttribute `style`
    var stringValues: seq[string]
    for value in values:
        stringValues &= $value
    element.attributes.add(attr("style", stringValues))
proc setStyle*(element: HtmlElement, values: seq[CssElementProperty]|varargs[CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `style`
    result = element
    result.setStyle(values)

proc setStyle*(element: var HtmlElement, values: varargs[CssElementProperty]|varargs[CssElement]) =
    ## Sets the HtmlAttribute `style`
    element.setStyle(values.toSeq())
proc setStyle*(element: HtmlElement, values: varargs[CssElementProperty]|varargs[CssElement]): HtmlElement =
    ## Sets the HtmlAttribute `style`
    result = element.setStyle(values.toSeq())
