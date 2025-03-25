import std/[strutils, strformat]
import ../logger, types

const
    cattagCssIndent* {.intdefine.}: int = 4


proc `$`*(property: CssElementProperty): string =
    ## Stringifies `CssElementProperty`
    if unlikely property.property == "":
        logWarning("Property has no name, will generate invalid CSS.")
    if unlikely property.values.len() == 0:
        logWarning(&"Property '{property.property}' has no values. Will generate invalid CSS.")
    result = property.property & ": " & property.values.join(" ") & ";"

proc `$`*(properties: seq[CssElementProperty], condensed: bool = false): string =
    ## Stringifies `CssElementProperty`s
    var resultList: seq[string]
    for property in properties:
        resultList &= $property
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
            selector & "{" & element.properties $ condensed & "}"
        else:
            selector & " {\n" &
                (element.properties $ condensed).indent(cattagCssIndent) &
            "\n}"

proc dollarCommentImpl(element: CssElement, condensed: bool): string =
    if element.comment.len() > 1 and not condensed:
        result = "/**" &
            element.comment.join("\n").indent(1, " * ") &
        "/*"
    else:
        result = "/*" & element.comment.join(" ") & "*/"


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


