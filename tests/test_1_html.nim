import std/[unittest]
import cattag

const elementWithChildren: string = """<div><div><p>some text</p></div></div>"""
test "Elements with children":
    check $newHtmlElement("div",
        newHtmlElement("div",
            newHtmlElement("p", "some text")
        )
    ) == elementWithChildren
    check $newHtmlElement("img", newHtmlElement("a", @[attr("href", "urmom.com")])) == "<img />"

const htmlDocument: string = """<!DOCTYPE html lang='en'>
<html lang='en'>
    <head lang='en'>
        <title>Homepage</title>
        <link href='favicon.png' rel='icon' sizes='32x32' type='image/png' />
        <script src='index.js' type='text/javascript'></script>
    </head>
    <body lang='en'>
        <main>
            <h1>My Homepage</h1>
            <p class='colourful'>Welcome to my little homepage!
            <br />
            I have some silly stuff here.</p>
        </main>
        <footer></footer>
    </body>
</html>"""
test "Documents":
    var document: HtmlDocument = newHtmlDocument("index.html")
    document.doctypeAttributes.add attr("lang", "en")
    document.htmlAttributes.add attr("lang", "en")
    document.headAttributes.add attr("lang", "en")
    document.bodyAttributes.add attr("lang", "en")
    document.addToHead(
        newHtmlElement("title", "Homepage"),
        newHtmlElement("link").add(
            attr("rel", "icon"),
            attr("type", "image/png"),
            attr("sizes", "32x32"),
            attr("href", "favicon.png")
        ),
        newHtmlElement("script", @[attr("type", "text/javascript"), attr("src", "index.js")])
    )
    document.addToBody(
        newHtmlElement("main",
            newHtmlElement("h1", "My Homepage"),
            newHtmlElement("p",
                "Welcome to my little homepage!",
                "I have some silly stuff here."
            ).add(attr("class", "colourful"))
        ),
        newHtmlElement("footer")
    )

    check htmlDocument == $document

test "Attribute setters":
    var element: HtmlElement = img()
    check $element == "<img />"

    element.setId("my-image")
    check $element == "<img id='my-image' />"

    element.setAlt("My image.")
    element.setSrc("image.png")

    let immutableElement: HtmlElement = img().setAlt("Immunatable image.").setSrc("image.png")

    check $element == "<img alt='My image.' id='my-image' src='image.png' />"
    check $immutableElement == "<img alt='Immunatable image.' src='image.png' />"
