import ../css/types

type
    # Attributes:
    Attribute* = object
        attribute*: string
        values*: seq[string]

    # Document elements:
    HtmlDocumentElement* = object of RootObj
    XmlDocumentElement* = object of RootObj

    # - Raw text:
    HtmlRawText* = object of HtmlDocumentElement
        content*: string
    XmlRawText* = object of XmlDocumentElement
        content*: string

    # - Normal elements:
    HtmlElement* = object of HtmlDocumentElement
        tag*: string
        attributes*: seq[Attribute]
        children*: seq[HtmlElement]
        style*: seq[CssElementProperty] ## TODO: similar "API" like the TS DOM
    XmlElement* = object of XmlDocumentElement
        tag*: string
        attributes*: seq[Attribute]
        children*: seq[XmlElement]

    # - Comments:
    HtmlComment* = object of HtmlDocumentElement
        lines*: seq[string]
    XmlComment* = object of XmlDocumentElement
        lines*: seq[string]

    # - XML prolog:
    XmlProlog* = seq[Attribute]

    # Document files:
    Document = object of RootObj
        file*: string
    HtmlDocument* = object of Document
        head*, body*: seq[HtmlDocumentElement]
    XmlDocument* = object of Document
        prolog*: XmlProlog
        body*: seq[XmlDocumentElement]

echo HtmlElement(tag: "a")
var a = new XmlElement
echo a.tag
