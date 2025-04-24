import cssTypes
export cssTypes
type
    CssElementType* = enum
        typeCssElement, typeCssComment
    CssSelectorType* = enum
        selectorElement, selectorId, selectorAll, selectorClass

    CssElementProperty* = object
        property*: string
        values*: seq[string]

    CssElement* = object
        case elementType*: CssElementType:
        of typeCssElement:
            selector*: string
            selectorType*: CssSelectorType = selectorElement
            properties*: seq[CssElementProperty]
        of typeCssComment:
            comment*: seq[string]

    CssStylesheet* = object
        file*: string = "styles.css"
        children*: seq[CssElement]
