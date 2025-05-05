import std/[strutils, strformat]
import ../logger, types

const
    cattagCssIndent* {.intdefine.}: int = 4

proc `$`*(element: CssElement, condensed: bool = false): string
proc `$`*(elements: seq[CssElement], condensed: bool = false): string


proc `$`*(property: CssElementProperty, condensed: bool = false): string =
    ## Stringifies `CssElementProperty`
    if unlikely property.property == "":
        logWarning("Property has no name, will generate invalid CSS.")
    if unlikely property.values.len() == 0:
        logWarning(&"Property '{property.property}' has no values. Will generate invalid CSS.")
    let sep: string = if condensed: ":" else: ": "
    result = property.property & sep & property.values.join(" ") & ";"

proc `$`*(properties: seq[CssElementProperty], condensed: bool = false): string =
    ## Stringifies `CssElementProperty`s
    var resultList: seq[string]
    for property in properties:
        resultList &= property $ condensed
    result = resultList.join(if condensed: "" else: "\n")


proc dollarImpl(element: CssElement, condensed: bool): string =
    let selector: string = block:
        var s: string = element.selector
        case element.selectorType:
        of selectorElement: discard
        of selectorAll: s = "*"
        of selectorClass:
            if not s.startsWith("."): s = "." & s
        of selectorId:
            if not s.startsWith("#"): s = "#" & s
        s

    result = block:
        if condensed:
            selector & "{" & element.children $ condensed & element.properties $ condensed & "}"
        else:
            selector & " {\n" &
                (if element.children.len() != 0:
                    (element.children $ condensed).indent(cattagCssIndent)
                else: "") &
                (if element.properties.len() != 0:
                    (element.properties $ condensed).indent(cattagCssIndent)
                else: "") &
            "\n}"

proc dollarCommentImpl(element: CssElement, condensed: bool): string =
    if element.comment.len() > 1 and not condensed:
        result = "/**\n" &
            element.comment.join("\n").indent(1, " * ") &
        "\n*/"
    else:
        result = "/* " & element.comment.join(" ") & " */"


proc `$`*(element: CssElement, condensed: bool = false): string =
    ## Stringifies `CssElement`
    result = case element.elementType:
        of typeCssElement: element.dollarImpl(condensed)
        of typeCssComment: element.dollarCommentImpl(condensed)

proc `$`*(elements: seq[CssElement], condensed: bool = false): string =
    ## Stringifies `CssElement`s
    var resultList: seq[string]
    for element in elements:
        resultList &= element $ condensed
    result = resultList.join(if condensed: "" else: "\n\n")

proc `$`*(stylesheet: CssStylesheet): string =
    ## Stringifies `CssStylesheet`
    result = $stylesheet.children & "\n"


proc writeFile*(stylesheet: CssStylesheet, filename: string) =
    ## Writes stylesheet to disk
    ##
    ## Raises `IOError` when not able to write to disk.
    filename.writeFile($stylesheet)
proc writeFile*(stylesheet: CssStylesheet) =
    ## Writes stylesheet to disk
    ##
    ## Raises `IOError` when `file` field is empty or could not write to disk.
    if unlikely stylesheet.file == "": raise IOError.newException("Stylesheet 'file' field is empty.")
    stylesheet.file.writeFile($stylesheet)
