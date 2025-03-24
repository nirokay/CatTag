import std/[strutils, strformat]
import ../logger, types

const
    cattagCssIndent* {.intdefine.}: int = 4
    elementSeparator: string = "\n" & repeat(" ", cattagCssIndent)

proc `$`*(property: CssElementProperty): string =
    ## Stringifies `CssElementProperty`
    if unlikely property.property == "":
        logWarning("Property has no name, will generate invalid CSS.")
    if unlikely property.values.len() == 0:
        logWarning(&"Property '{property.property}' has no values. Will generate invalid CSS.")
    result = property.property & ": " & property.values.join(" ") & ";"

proc `$`*(element: CssElement, joinByNewLineAndIndent: bool = true): string =
    let
        sep: string = if joinByNewLineAndIndent: elementSeparator else: ""
        selector: string = block:
            var s: string = element.selector
            case element.selectorType:
            of selectorElement: discard
            of selectorAll: s = "*"
            of selectorClass:
                if not s.startsWith("."): s = "." & s
            of selectorId:
                if not s.startsWith("#"): s = "#" & s
            s

    result = selector & " {" & sep
    for p in element.properties:
        let property: string = $p
        result.add property & sep
    result.add "}"
