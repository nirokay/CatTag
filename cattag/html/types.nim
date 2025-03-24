import ../css/types

type
    HtmlDocumentElement* = object of RootObj

    HtmlElementAttribute* = object
        attribute*: string
        values*: seq[string]

    HtmlElement* = object of HtmlDocumentElement
        tag*: string
        attributes*: seq[HtmlElementAttribute]
        style*: seq[CssElementProperty]
        children*: seq[HtmlElement]

    HtmlComment* = object of HtmlDocumentElement
        lines*: seq[string]

    HtmlDocument* = object
        file*: string = "index.html"
        children*: seq[HtmlDocumentElement]
