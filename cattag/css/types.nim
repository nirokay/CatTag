type
    CssStylesheetElement* = object of RootObj

    CssSelectorType* = enum
        selectorElement, selectorId, selectorAll, selectorClass

    CssElementProperty* = object
        property*: string
        values*: seq[string]

    CssElement* = object of CssStylesheetElement
        selector*: string
        selectorType*: CssSelectorType = selectorElement
        properties*: seq[CssElementProperty]

    CssComment* = object of CssStylesheetElement
        lines*: seq[string]

    CssStylesheet* = object
        file*: string = "styles.css"
        children*: seq[CssStylesheetElement]
