import std/[sequtils, strutils, strformat, tables, algorithm]
import ../logger, types, rules, procs

const
    cattagHtmlXmlAttributeQuote* {.strdefine.} = "'" ## Quote used for attribute values (`"` or `'`)
    cattagHtmlXmlSortAttributes* {.booldefine.} = true ## Toggles alphabetical sorting of attributes
    cattagHtmlXmlIndent* {.intdefine.} = 4 ## Sets indent for children (if set to zero, output will be inline)
    cattagHtmlTrailingSlash* {.booldefine.} = true ## Toggles if `br` should generate `<br />` instead of `<br>`
    cattagXmlSelfCloseOnEmptyChildren* {.booldefine.} = true ## Toggles if no children will generate `<some-text />` instead of `<some-text></some-text>` (good practice for XML)
    cattagHtmlGenerateEmptyAttributeValue* {.booldefine.} = false ## Toggles if `<script defer="">...</script>` should be generated instead of `<script defer>...</script>` for HTML

    htmlVoidElementSlash: string = if cattagHtmlTrailingSlash: " /" else: ""
    xmlVoidElementSlash: string = if cattagXmlSelfCloseOnEmptyChildren: " /" else: ""

    htmlXmlIndentNewLine: string = if cattagHtmlXmlIndent > 0: "\n" else: ""

proc cmpAttributes(x, y: Attribute): int = cmp($x, $y)
proc sortedAttributes(attributes: seq[Attribute]): seq[Attribute] =
    if not cattagHtmlXmlSortAttributes: return attributes
    result = attributes
    result.sort(cmpAttributes)
proc getElementWithMergedSortedAttributes[T: HtmlElement|XmlElement](element: T): T =
    var tableAttributes: Table[string, seq[string]]
    for attribute in element.attributes:
        if not tableAttributes.hasKey(attribute.attribute):
            tableAttributes[attribute.attribute] = @[]
        tableAttributes[attribute.attribute] &= attribute.values

    var attributes: seq[Attribute]
    for attribute, values in tableAttributes:
        attributes.add newAttribute(attribute, values.deduplicate())

    result = element
    result.attributes = attributes.sortedAttributes()


proc `$`*(attribute: Attribute, generateEmptyValue: bool = false): string =
    ## Stringifies `Attribute` for HTML and XML
    let value: string = attribute.values.join(" ")
    result = block:
        if value == "" and not generateEmptyValue: &" {attribute.attribute}"
        else: &" {attribute.attribute}={cattagHtmlXmlAttributeQuote}{value}{cattagHtmlXmlAttributeQuote}"
proc `$`*(attributes: seq[Attribute], generateEmptyValue: bool = false): string =
    ## Stringifies `Attribute`s for HTML and XML
    for attribute in attributes:
        result.add $attribute


proc dollarImpl(element: HtmlElement): string
proc dollarImpl(element: XmlElement): string

proc dollarImpl(elements: seq[HtmlElement]): string
proc dollarImpl(elements: seq[XmlElement]): string


proc stringifyRawText(element: HtmlElement): string =
    element.content.join("\n" & newHtmlElement("br").dollarImpl() & "\n")
proc stringifyRawText(element: XmlElement): string =
    element.content.join("\n")
proc stringifyComment(element: HtmlElement|XmlElement): string =
    result = @[
        "<!--",
        element.comment.join("\n").indent(cattagHtmlXmlIndent),
        "--->"
    ].join(if htmlXmlIndentNewLine != "": htmlXmlIndentNewLine else: " ")

proc stringifyElement[T: HtmlElement|XmlElement](element: T, isVoid: bool, generateEmptyValue: bool): string =
    if unlikely(isVoid and element.children.len() != 0): logWarning(&"Element with tag '{element.tag}' has children but is void. Children will not be generated!")
    let
        trailingSlash: string = block:
            if element is HtmlElement: htmlVoidElementSlash
            elif element is XmlElement: xmlVoidElementSlash
            else:
                logFatal("Unsupported type.")
                ""
        attributes: string = element.getElementWithMergedSortedAttributes().attributes $ generateEmptyValue
    if isVoid:
        result = &"<{element.tag}{attributes}{trailingSlash}>"
    else:
        if element.children.len() == 0:
            result = &"<{element.tag}{attributes}></{element.tag}>"
        else:
            result = &"<{element.tag}{attributes}>{htmlXmlIndentNewLine}" & dollarImpl(element.children).indent(cattagHtmlXmlIndent) & &"{htmlXmlIndentNewLine}</{element.tag}>"

proc stringifyHtmlElement(element: HtmlElement): string =
    let isVoid: bool = element.tag in htmlVoidElementTags
    var modifiedElement: HtmlElement = element # TODO: implement `style` field converting to attribute
    result = modifiedElement.stringifyElement(isVoid, cattagHtmlGenerateEmptyAttributeValue)

proc stringifyXmlElement(element: XmlElement): string =
    let isVoid: bool = element.children.len() == 0 and cattagXmlSelfCloseOnEmptyChildren
    result = element.stringifyElement(isVoid, true)

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
    var strings: seq[string]
    for element in elements:
        strings.add element.dollarImpl()
    result = strings.join(htmlXmlIndentNewLine)
proc dollarImpl(elements: seq[XmlElement]): string =
    var strings: seq[string]
    for element in elements:
        strings.add element.dollarImpl()
    result = strings.join(htmlXmlIndentNewLine)


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


proc `$`*(document: HtmlDocument): string =
    ## Stringifies `HtmlDocument`
    let
        doctype: string = "<!DOCTYPE html" & $document.doctypeAttributes & ">"
        elements: seq[HtmlElement] = @[
            rawHtmlText(doctype),
            newHtmlElement("html", document.htmlAttributes,
                newHtmlElement("head", document.headAttributes,
                    document.head
                ),
                newHtmlElement("body", document.bodyAttributes,
                    document.body
                )
            )
        ]
    result = $elements
proc `$`*(document: XmlDocument): string =
    ## Stringifies `XmlDocument`
    let
        prologAttributes: XmlProlog = block:
            if document.prolog.len() != 0: document.prolog
            else: @[attr("version", "1.0"), attr("encoding", "utf-8")]
        prolog: string = "<?xml" & $prologAttributes & "?>"
        elements: seq[XmlElement] = @[rawXmlText(prolog)] & document.body
    result = $elements


template writeDocument(OBJECT_TYPE: typedesc): untyped =
    proc writeFile*(document: OBJECT_TYPE, filename: string) =
        ## Writes document to disk
        ##
        ## Raises `IOError` when not able to write to disk.
        filename.writeFile($document)
    proc writeFile*(document: OBJECT_TYPE) =
        ## Writes document to disk
        ##
        ## Raises `IOError` when `file` field is empty or could not write to disk.
        if unlikely document.file == "": raise IOError.newException("Document 'file' field is empty.")
        document.file.writeFile($document)

writeDocument(HtmlDocument)
writeDocument(XmlDocument)
