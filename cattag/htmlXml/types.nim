import ../css/types

type
    # Attributes:
    Attribute* = object
        attribute*: string
        values*: seq[string]

    # Document elements:
    HtmlDocumentElement* = object of RootObj
    XmlDocumentElement* = object of RootObj

    # - Normal elements:
    HtmlElement* = object of HtmlDocumentElement
        tag*: string
        attributes*: seq[Attribute]
        children*: seq[HtmlElement]
        style*: seq[CssElementProperty] ## TODO: similar "API" like the JS DOM
    XmlElement* = object of XmlDocumentElement
        tag*, additionalTagPart*: string
        attributes*: seq[Attribute]
        children*: seq[XmlElement]

    # - Comments:
    HtmlComment* = object of HtmlDocumentElement
        lines*: seq[string]
    XmlComment* = object of XmlDocumentElement
        lines*: seq[string]

    # Document files:
    Document = object of RootObj
        file*: string
    HtmlDocument* = object of Document
        head*, body*: seq[HtmlDocumentElement]
    XmlDocument* = object of Document
        body*: seq[XmlDocumentElement]

echo HtmlElement(tag: "a")
var a = new XmlElement
echo a.tag
