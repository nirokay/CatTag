import ../css/types

type
    # Attributes:
    Attribute* = object
        attribute*: string
        values*: seq[string]

    # Document elements:
    DocumentElementType* = enum
        typeElement, typeComment, typeRawText

    HtmlElement* = object
        case elementType*: DocumentElementType:
        of typeElement:
            tag*: string
            attributes*: seq[Attribute]
            children*: seq[HtmlElement]
            style*: seq[CssElementProperty] ## TODO: similar "API" like the TS DOM
        of typeComment:
            comment*: seq[string]
        of typeRawText:
            content*: seq[string]
    XmlElement* = object
        case elementType*: DocumentElementType:
        of typeElement:
            tag*: string
            attributes*: seq[Attribute]
            children*: seq[XmlElement]
        of typeComment:
            comment*: seq[string]
        of typeRawText:
            content*: seq[string]

    # - XML prolog:
    XmlProlog* = seq[Attribute]

    # Document files:
    Document = object of RootObj
        file*: string
    HtmlDocument* = object of Document
        head*, body*: seq[HtmlElement]
        doctypeAttributes*, htmlAttributes*, headAttributes*, bodyAttributes*: seq[Attribute]
    XmlDocument* = object of Document
        prolog*: XmlProlog
        body*: seq[XmlElement]
