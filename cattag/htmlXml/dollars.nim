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


proc dollarImpl(element: HtmlElement): string
proc dollarImpl(element: XmlElement): string

proc dollarImpl(elements: seq[HtmlElement]): string
proc dollarImpl(elements: seq[XmlElement]): string


proc stringifyRawText(element: HtmlElement|XmlElement): string =
    element.content.join("\n")
proc stringifyComment(element: HtmlElement|XmlElement): string =
    result = @[
        "<!--",
        element.comment.join("\n").indent(cattagHtmlXmlIndent),
        "--->"
    ]. join("\n").indent(cattagHtmlXmlIndent)

proc stringifyElement[T: HtmlElement|XmlElement](element: T, isVoid: bool): string =
    if unlikely(isVoid and element.children.len() != 0): logWarning(&"Element with tag {element.tag} has children but is void. Children will not be generated!")
    let
        trailingSlash: string = block:
            if element is HtmlElement: htmlVoidElementSlash
            elif element is XmlElement: xmlVoidElementSlash
            else:
                logFatal("Unsupported type.")
                ""
        attributes: seq[Attribute] = element.getElementWithSortedAttributes().attributes
    if isVoid:
        result = &"<{element.tag}{attributes}{trailingSlash}>"
    else:
        result = &"<{element.tag}{attributes}>{htmlXmlIndentNewLine}" & dollarImpl(element.children).indent(cattagHtmlXmlIndent) & &"{htmlXmlIndentNewLine}</{element.tag}>"

proc stringifyHtmlElement(element: HtmlElement): string =
    let isVoid: bool = element.tag in voidElementTags
    result = element.stringifyElement(isVoid)

proc stringifyXmlElement(element: XmlElement): string =
    let isVoid: bool = element.children.len() == 0 and cattagXmlSelfCloseOnEmptyChildren
    result = element.stringifyElement(isVoid)

proc dollarImpl(element: HtmlElement): string =
    case element.elementType:
    of typeComment: element.stringifyComment()
    of typeElement: element.stringifyHtmlElement()
    of typeRawText: element.stringifyRawText()
proc dollarImpl(element: XmlElement): string =
    case element.elementType:
    of typeComment: element.stringifyComment()
    of typeElement: element.stringifyXmlElement()
    of typeRawText: element.stringifyRawText()

proc dollarImpl(elements: seq[HtmlElement]): string =
    for element in elements:
        result &= element.dollarImpl()
proc dollarImpl(elements: seq[XmlElement]): string =
    for element in elements:
        result &= element.dollarImpl()


proc `$`*(element: HtmlElement): string =
    ## Stringifies `HtmlElement`
    result = element.dollarImpl()
proc `$`*(element: XmlElement): string =
    ## Stringifies `XmlElement`
    result = element.dollarImpl()

proc `$`*(elements: seq[HtmlElement]): string =
    ## Stringifies `HtmlElement`s
    result = elements.dollarImpl()
proc `$`*(elements: seq[XmlElement]): string =
    ## Stringifies `XmlElement`s
    result = elements.dollarImpl()
