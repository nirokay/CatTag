import std/[unittest, strutils]
import cattag

test "Attributes":
    check $attr("href", "https://www.nirokay.com/") == " href='https://www.nirokay.com/'"
    check $attr("defer") == " defer"
    check $attr("class", "centered", "dark-mode", "urmom") == " class='centered dark-mode urmom'"

test "Raw text":
    check $rawHtmlText("hello world") == "hello world"

const htmlComment: string = """<!--
    hello world
--->"""
const longHtmlComment: string = """<!--
    hello world
    how are you?
--->"""
const longerHtmlComment: string = """<!--
    even
    longer
    now
--->"""
const longestHtmlComment: string = """<!--
    WOAH
    SO
    LONG
    COMMENT
--->"""
test "Comments":
    check $newHtmlComment("hello world") == htmlComment
    check $newHtmlComment("hello world", "how are you?") == longHtmlComment
    check $newHtmlComment("even", "longer", "now") == longerHtmlComment
    check $newHtmlComment("WOAH", "SO", "LONG", "COMMENT") == longestHtmlComment

const elementWithContent: string = """<tag>
    hello world
</tag>"""
test "Elements":
    check $newHtmlElement("tag") == "<tag></tag>"
    # Raw text:
    check $newHtmlElement("tag", rawHtmlText("hello world")) == elementWithContent
    check $newHtmlElement("tag", "hello world") == elementWithContent
    check $newHtmlElement("img", rawHtmlText("hello world")) == "<img />"

test "Elements with attributes (with sorting)":
    check $newHtmlElement("img", @[attr("src", "https://www.nirokay.com/favicon.gif"), attr("alt", "Favicon")]) ==
        "<img alt='Favicon' src='https://www.nirokay.com/favicon.gif' />"

const elementWithChildren: string = """<div>
    <div>
        <p>
            some text
        </p>
    </div>
</div>"""
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
        <title>
            Homepage
        </title>
        <link href='favicon.png' rel='icon' sizes='32x32' type='image/png' />
        <script src='index.js' type='text/javascript'></script>
    </head>
    <body lang='en'>
        <main>
            <h1>
                My Homepage
            </h1>
            <p class='colourful'>
                Welcome to my little homepage!
                <br />
                I have some silly stuff here.
            </p>
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
