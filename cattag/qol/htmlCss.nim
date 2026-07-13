import ../htmlXml/all
import ../css/types


# Stylesheet: -----------------------------------------------------------------

proc applyStylesheet*(html: var HtmlDocument, path: string) =
    ## Adds a stylesheet to the head of the document
    html.addToHead newHtmlElement("link", @[
        newAttribute("rel", "stylesheet"),
        newAttribute("href", path)
    ])
proc applyStylesheet*(html: var HtmlDocument, stylesheet: CssStylesheet) =
    ## Adds a stylesheet to the head of the document
    html.applyStylesheet(stylesheet.file)

proc applyStylesheet*(html: HtmlDocument, path: string): HtmlDocument =
    ## Adds a stylesheet to the head of the document
    result = html
    result.applyStylesheet(path)
proc applyStylesheet*(html: HtmlDocument, stylesheet: CssStylesheet): HtmlDocument =
    ## Adds a stylesheet to the head of the document
    result = html.applyStylesheet(stylesheet.file)
