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

    htmlXmlIndentNewLine: string = if cattagHtmlXmlIndent > 0: "\n" else: ""

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


template indent(): string =
    if htmlXmlIndentNewLine != "": htmlXmlIndentNewLine & repeat(" ", indentLevel)
    else: ""
template nextIndent(): int =
    indentLevel + cattagHtmlXmlIndent

proc dollarAll(element: HtmlElement|XmlElement, indentLevel: int): string ## Stringifies `HtmlElement`
proc dollarAll(element: seq[HtmlElement|XmlElement], indentLevel: int): string ## Stringifies `HtmlElement`
proc dollarComment(element: HtmlElement|XmlElement, indentLevel: int): string ## Stringifies `HtmlElement`
proc dollarHtmlRawText(element: HtmlElement, indentLevel: int): string ## Stringifies `HtmlElement`
proc dollarXmlRawText(element: XmlElement, indentLevel: int): string ## Stringifies `XmlElement`
proc dollarElement(element: HtmlElement, indentLevel: int): string ## Stringifies `HtmlElement`
proc dollarElement(elements: seq[HtmlElement]|seq[XmlElement], indentLevel: int): string
proc dollarElement(element: XmlElement, indentLevel: int): string ## Stringifies `XmlElement`

proc dollarHtmlRawText(element: HtmlElement, indentLevel: int): string =
    ## Stringifies `HtmlRawText` (raw text child)
    result = element.content.join(dollarElement(HtmlElement(elementType: typeElement, tag: "br"), indentLevel))
proc dollarXmlRawText(element: XmlElement, indentLevel: int): string =
    ## Stringifies `XmlRawText` (raw text child)
    result = element.content.join("\n").indent(indentLevel)


proc dollarComment(element: HtmlElement|XmlElement, indentLevel: int): string =
    # TODO: implementation
    ""


proc getTrailingSlash(element: HtmlElement, isVoid: bool): string = (if isVoid: result = htmlVoidElementSlash)
proc getTrailingSlash(element: XmlElement, isVoid: bool): string = (if isVoid: result = xmlVoidElementSlash)

proc unifiedElementStringification[T: HtmlElement|XmlElement](element: T, isVoid: bool, indentLevel: int): string =
    let
        trailingSlash: string = element.getTrailingSlash(isVoid)
        elem: T = element.getElementWithSortedAttributes()
    result = (
        if isVoid: &"<{elem.tag}{$elem.attributes}{trailingSlash}>"
        else:
            let children: string = dollarAll(elem.children, indentLevel + cattagHtmlXmlIndent)
            &"<{elem.tag}{$elem.attributes}>" & (if children.len() != 0: "\n" else: "") & indent() & children & &"</{elem.tag}>"
    )

proc dollarElement(element: HtmlElement, indentLevel: int): string =
    ## Stringifies `HtmlElement`
    # TODO: `style` field conversion to attributes
    var isVoid: bool = false
    if element.tag in voidElementTags:
        isVoid = true
        if unlikely element.children.len() != 0: logWarning(&"Element with tag '{element.tag}' is void element, but has children. Children will not be generated.")
    result = element.unifiedElementStringification(isVoid, indentLevel)
proc dollarElement(element: XmlElement, indentLevel: int): string =
    ## Stringifies `XmlElement`
    var isVoid: bool = false
    if cattagXmlSelfCloseOnEmptyChildren:
        if element.children.len() == 0: isVoid = true
    result = element.unifiedElementStringification(isVoid, indentLevel)
proc dollarElement(elements: seq[HtmlElement]|seq[XmlElement], indentLevel: int): string =
    for element in elements:
        result &= element.dollarElement(indentLevel)

proc dollarAll(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    case element.elementType:
    of typeElement: element.dollarElement(0)
    of typeComment: element.dollarComment(0)
    of typeRawText: element.dollarHtmlRawText(0)
proc dollarAll(element: XmlElement): string =
    ## Stringifies `XmlElement`
    case element.elementType:
    of typeElement: element.dollarElement(0)
    of typeComment: element.dollarComment(0)
    of typeRawText: element.dollarXmlRawText(0)

proc dollarAll(elements: seq[HtmlElement]): string =
    ## Stringifies `HtmlElement`s
    if elements.len() == 0: return ""
    for element in elements:
        result &= $element
proc dollarAll(elements: seq[XmlElement]): string =
    ## Stringifies `XmlElement`s
    if elements.len() == 0: return ""
    for element in elements:
        result &= $element


proc `$`*(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    result = element.dollarAll()
proc `$`*(element: XmlElement): string =
    ## Stringifies `XmlElement`
    result = element.dollarAll()

proc `$`*(elements: seq[HtmlElement]): string =
    ## Stringifies `HtmlElement`s
    result = elements.dollarAll()
proc `$`*(elements: seq[XmlElement]): string =
    ## Stringifies `XmlElement`s
    result = elements.dollarAll()
