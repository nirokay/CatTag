import std/[strutils, strformat, algorithm]
import ../logger, types, rules

const
    cattagHtmlXmlAttributeQuote* {.strdefine.} = "'" ## Quote used for attribute values (`"` or `'`")
    cattagHtmlXmlSortAttributes* {.booldefine.} = true ## Toggles alphabetical sorting of attributes
    cattagHtmlXmlIndent* {.intdefine.} = 4 ## Sets indent for children (if set to zero, output will be inline)
    cattagHtmlTrailingSlash* {.booldefine.} = true ## Toggles if `br` should generate `<br />` instead of `<br>`
    cattagXmlSelfCloseOnEmptyChildren* {.booldefine.} = true ## Toggles if no children will generate `<some-text />` instead of `<some-text></some-text>` (good practice for XML)

    htmlVoidElementSlash: string = if cattagHtmlTrailingSlash: " /" else: ""
    xmlVoidElementSlash: string = if cattagXmlSelfCloseOnEmptyChildren: " /" else: ""

proc cmpAttributes(x, y: Attribute): int = cmp($x, $y)
proc sortedAttributes(attributes: seq[Attribute]): seq[Attribute] =
    if not cattagHtmlXmlSortAttributes: return attributes
    result = attributes
    result.sort(cmpAttributes)
proc getElementWithSortedAttributes[T: HtmlElement|XmlElement](element: T): T =
    var attributes: seq[Attribute] = element.attributes.sortedAttributes()
    result = element
    result.attributes = attributes


proc `$`*(attribute: Attribute): string =
    ## Stringifies `Attribute` for HTML and XML
    let value: string = attribute.values.join(" ")
    result = block:
        if value == "": &" {attribute.attribute}"
        else: &" {attribute.attribute}={cattagHtmlXmlAttributeQuote}{value}{cattagHtmlXmlAttributeQuote}"
proc `$`*(attributes: seq[Attribute]): string =
    ## Stringifies `Attribute`s for HTML and XML
    for attribute in attributes:
        result.add $attribute


proc `$`*(element: HtmlElement): string ## Stringifies `HtmlElement`
proc `$`*(element: XmlElement): string ## Stringifies `XmlElement`
proc `$`*(elements: seq[HtmlElement]): string ## Stringifies `HtmlElement`s
proc `$`*(elements: seq[XmlElement]): string ## Stringifies `XmlElement`s

proc dollarHtmlRawText*(element: HtmlElement): string =
    ## Stringifies `HtmlRawText` (raw text child)
    result = element.content.join($HtmlElement(elementType: typeElement, tag: "br"))
proc dollarXmlRawText*(element: XmlElement): string =
    ## Stringifies `XmlRawText` (raw text child)
    result = element.content.join("\n")


proc dollarComment*(element: HtmlElement|XmlElement): string =
    # TODO: implementation
    ""


proc getTrailingSlash(element: HtmlElement, isVoid: bool): string = (if isVoid: result = htmlVoidElementSlash)
proc getTrailingSlash(element: XmlElement, isVoid: bool): string = (if isVoid: result = xmlVoidElementSlash)
proc unifiedElementStringification[T: HtmlElement|XmlElement](element: T, isVoid: bool): string =
    let
        trailingSlash: string = element.getTrailingSlash(isVoid)
        elem: T = element.getElementWithSortedAttributes()
    result = block:
        if isVoid: &"<{elem.tag}{$elem.attributes}{trailingSlash}>"
        else: &"<{elem.tag}{$elem.attributes}>{$elem.children}</{elem.tag}>"

proc dollarHtmlElement(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    # TODO: `style` field conversion to attributes
    var isVoid: bool = false
    if element.tag in voidElementTags:
        isVoid = true
        if unlikely element.children.len() != 0: logWarning(&"Element with tag '{element.tag}' is void element, but has children. Children will not be generated.")
    result = element.unifiedElementStringification(isVoid)
proc dollarXmlElement(element: XmlElement): string =
    ## Stringifies `XmlElement`
    var isVoid: bool = false
    if cattagXmlSelfCloseOnEmptyChildren:
        if element.children.len() == 0: isVoid = true
    result = element.unifiedElementStringification(isVoid)


proc `$`*(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    case element.elementType:
    of typeElement: element.dollarHtmlElement()
    of typeComment: element.dollarComment()
    of typeRawText: element.dollarHtmlRawText()
proc `$`*(element: XmlElement): string =
    ## Stringifies `XmlElement`
    case element.elementType:
    of typeElement: element.dollarXmlElement()
    of typeComment: element.dollarComment()
    of typeRawText: element.dollarXmlRawText()

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
