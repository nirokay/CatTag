import std/[strutils, strformat, json, tables, options]
import ../../htmlXml/rules
import parser

type
    ElementCommonAttributes = object
        acceptChildren*: Option[bool]
        acceptContent*: Option[bool]
        attributes*: OrderedTable[string, string]
    ElementsCommonAttributesFile = OrderedTable[string, seq[ElementCommonAttributes]]

let elementCommonAttributes: ElementsCommonAttributesFile = readFile("./resources/html-elements-common-attributes.json").parseJson().to(ElementsCommonAttributesFile)

const templateVoidProcs: string = """# General procs for SELECTED_TAG:
proc QUOTED_SELECTED_TAG*(): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG")
proc QUOTED_SELECTED_TAG*(attributes: seq[Attribute]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", attributes: attributes)"""
const templateChildAcceptingProcs: string = """# General children procs for SELECTED_TAG:
proc QUOTED_SELECTED_TAG*(attributes: seq[Attribute], children: seq[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", attributes: attributes, children: children)
proc QUOTED_SELECTED_TAG*(attributes: seq[Attribute], child: HtmlElement, children: varargs[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", attributes: attributes, children: @[child] & children.toSeq())

proc QUOTED_SELECTED_TAG*(children: seq[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", children: children)
proc QUOTED_SELECTED_TAG*(child: HtmlElement, children: varargs[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", children: @[child] & children.toSeq())

proc QUOTED_SELECTED_TAG*(attributes: seq[Attribute], content: seq[string]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", attributes: attributes, children: @[rawHtmlText(content)])
proc QUOTED_SELECTED_TAG*(attributes: seq[Attribute], content: string, moreContent: varargs[string]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", attributes: attributes, children: @[rawHtmlText(@[content] & moreContent.toSeq())])"""
#[
proc PROC_NAME*(content: seq[string]): HtmlElement =
    ## Constructs new element
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", children: @[rawHtmlText(content)])
proc PROC_NAME*(content: string, moreContent: varargs[string]): HtmlElement =
    ## Constructs new element
    result = HtmlElement(elementType: typeElement, tag: "SELECTED_TAG", children: @[rawHtmlText(@[content] & moreContent.toSeq())])
]#

const templateCustomAttrVoidProcs: string = """# Custom attribute procs for void SELECTED_TAG:
proc QUOTED_SELECTED_TAG*(ATTRIBUTES): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = QUOTED_SELECTED_TAG(ATTR_LIST)"""
const templateCustomAttrChildrenProcs: string = """# Custom attribute procs with children for SELECTED_TAG:
proc QUOTED_SELECTED_TAG*(ATTRIBUTES, children: seq[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = QUOTED_SELECTED_TAG(ATTR_LIST, children)
proc QUOTED_SELECTED_TAG*(ATTRIBUTES, child: HtmlElement, children: varargs[HtmlElement]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = QUOTED_SELECTED_TAG(ATTR_LIST, @[child] & children.toSeq())"""
const templateCustomAttrWithContentProcs: string = """# Custom attribute procs with content for SELECTED_TAG:
proc QUOTED_SELECTED_TAG*(ATTRIBUTES, content: seq[string]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = QUOTED_SELECTED_TAG(ATTR_LIST, rawHtmlText(content))
proc QUOTED_SELECTED_TAG*(ATTRIBUTES, content: string, contents: varargs[string]): HtmlElement =
    ## Constructs new element
    ## REFERENCE
    result = QUOTED_SELECTED_TAG(ATTR_LIST, rawHtmlText(@[content] & contents.toSeq()))"""

proc newConstructorProcs(tag: string, reference: string): string =
    var lines: seq[string]
    let rawTag: string = tag.replace("`", "")
    proc modify(input: string, attributeLine: string = "", attributeList: string = ""): string =
        input.strip()
            .replace("QUOTED_SELECTED_TAG", tag)
            .replace("SELECTED_TAG", rawTag)
            .replace("REFERENCE", reference)
            .replace("ATTRIBUTES", attributeLine)
            .replace("ATTR_LIST", attributeList)

    # General procs:
    lines &= templateVoidProcs.modify()
    if rawTag notin htmlVoidElementTags:
        lines &= templateChildAcceptingProcs.modify()

    # Specific attr procs:
    if elementCommonAttributes.hasKey(rawTag):
        for rule in elementCommonAttributes[rawTag]:
            # Every instance of custom attributes:
            let
                acceptChildren: bool = rule.acceptChildren.get(true)
                acceptContent: bool = rule.acceptContent.get(false)
                attributes: seq[array[2, string]] = block:
                    var r: seq[array[2, string]]
                    let attrTable: OrderedTable[string, string] = rule.attributes
                    for attrName, attrType in attrTable:
                        r.add([attrName, attrType])
                    r
                attributeLine: string = block:
                    var r: seq[string]
                    for attr in attributes:
                        r.add &"{attr[0]}: {attr[1]}"
                    r.join(", ")
                attributeList: string = block:
                    var r: seq[string]
                    for attribute in attributes:
                        r.add(@[
                            "attr(\"",
                            attribute[0].replace("`", ""),
                            "\", ",
                            attribute[0],
                            ")"
                        ].join(""))
                    "@[" & r.join(", ") & "]"

            lines &= templateCustomAttrVoidProcs.modify(attributeLine, attributeList)
            if rawTag notin htmlVoidElementTags and acceptChildren:
                lines &= templateCustomAttrChildrenProcs.modify(attributeLine, attributeList)
            if rawTag notin htmlVoidElementTags and acceptContent:
                lines &= templateCustomAttrWithContentProcs.modify(attributeLine, attributeList)

    # Join all lines:
    result = lines.join("\n\n")

    # Special rule for headings:
    if rawTag == "h1":
        for number in 2 .. 6:
            result &= "\n\n\n" & newConstructorProcs("h" & $number, reference[0 .. ^2] & $number)


let needQuoting: seq[string] = @[
    "div",
    "object",
    "template",
    "var"
]

var output: OutputFile = newOutputFile("htmlElements.nim")
output.lines = @[
    "## HTML Elements",
    "## =============",
    "##",
    "## This module is autogenerated with a list of HTML elements.",
    "",
    "import std/[sequtils]",
    "import ../htmlXml/[types, procs]",
    ""
]

for fileLine in parseFileLines("html-elements.txt"):
    let
        splitString: seq[string] = fileLine.split(" ")
        rawTag: string = splitString[0][1 .. ^2] # Remove brackets
        quote: string = if rawTag notin needQuoting: "" else: "`"
        quotedTag: string = quote & rawTag & quote
        reference: string = &"Reference: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/{rawTag}"

    block stringConstant:
        # String constant, useful for sugar declarations:
        # ```nim
        # let element: HtmlElement = p[
        #     rawHtmlText("hello world")
        # ]
        # ```
        break stringConstant
        #[
        let
            components: seq[string] = if splitString.len() == 1: @[] else: splitString[1 .. ^1]
            additionalInformation: string = block:
                if components.len() == 0: ""
                else: "Notes: [" & components.join(", ") & "] "
            deprecationNotice: string = block:
                if "Deprecated" notin components: ""
                else:
                    " {.deprecated: \"Deprecated in newer HTML versions\".}"
            documentation: string = &"HtmlTag `{rawTag}` {additionalInformation}{reference}"

        let line: string = &"const {quotedTag}*{deprecationNotice}: HtmlTag = \"{rawTag}\" ## {documentation}"
        output.lines.add(line)
        ]#

    block constructorProcs:
        let procsLines: string = newConstructorProcs(quotedTag, reference)
        output.lines.add("\n" & procsLines & "\n\n")


output.lines.add("")
output.writeFile()
