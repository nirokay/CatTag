import std/[strutils, strformat]
import types

const
    cattagHtmlXmlAttributeQuote* {.strdefine.} = "'"
    cattagHtmlXmlSortAttributes* {.booldefine.} = true
    cattagHtmlTrailingSlash* {.booldefine.} = true
    cattagXmlTrailingSlashOnEmptyChildren* {.booldefine.} = true

    htmlVoidElementSlash: string = if cattagHtmlTrailingSlash: " /" else: ""
    xmlVoidElementSlash: string = if cattagXmlTrailingSlashOnEmptyChildren: " /" else: ""


proc `$`*(attribute: Attribute): string =
    ## Stringifies `Attribute` for HTML and XML
    let value: string = attribute.values.join(" ")
    result = &" {attribute.attribute}={cattagHtmlXmlAttributeQuote}{value}{cattagHtmlXmlAttributeQuote}"
proc `$`*(attributes: seq[Attribute]): string =
    ## Stringifies `Attribute`s for HTML and XML
    for attribute in attributes:
        result.add $attribute


template dollarRawString(OBJECT_TYPE: typedesc): untyped =
    proc `$`*(element: OBJECT_TYPE): string =
        ## Stringifies `OBJECT_TYPE` (raw text child)
        result = element.content
dollarRawString(HtmlRawText)
dollarRawString(XmlRawText)


proc `$`*(element: HtmlElement): string ## Stringifies `HtmlElement`
proc `$`*(element: XmlElement): string ## Stringifies `XmlElement`
proc `$`*(elements: seq[HtmlElement]): string ## Stringifies `HtmlElement`s
proc `$`*(elements: seq[XmlElement]): string ## Stringifies `XmlElement`s

proc getTrailingSlash(element: HtmlElement, isVoid: bool): string = (if isVoid: result = htmlVoidElementSlash)
proc getTrailingSlash(element: XmlElement, isVoid: bool): string = (if isVoid: result = xmlVoidElementSlash)
proc unifiedElementStringification(element: HtmlElement|XmlElement, isVoid: bool): string =
    let trailingSlash: string = element.getTrailingSlash(isVoid)
    result = block:
        if isVoid: &"<{element.tag}{$element.attributes}{trailingSlash}>"
        else: &"<{element.tag}{$element.attributes}>{$element.children}</{element.tag}>"

proc `$`*(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    # TODO: `style` field conversion to attributes
    ""
proc `$`*(element: XmlElement): string =
    ## Stringifies `XmlElement`
    ""

proc `$`*(elements: seq[HtmlElement]): string =
    ## Stringifies `HtmlElement`s
    if elements.len() == 0: return ""
    for element in elements:
        result &= $element
proc `$`*(elements: seq[XmlElement]): string =
    ## Stringifies `XmlElement`s
    if elements.len() == 0: return ""
    for element in elements:
        result &= $element
