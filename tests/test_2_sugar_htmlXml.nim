import std/[unittest]
import cattag

let simpleElement: string = """<p>
    Hello world!
    How are you?
</p>"""
test "Element with children":
    check simpleElement == $"p"[
        rawHtmlText "Hello world!",
        rawHtmlText "How are you?"
    ]
    check simpleElement == $"p"[
        rawXmlText "Hello world!",
        rawXmlText "How are you?"
    ]

let attrElement0: string = """<img src='image.png' />"""
let attrElement1: string = """<img alt='image' src='image.png' />"""
test "Element with attributes":
    var element: HtmlElement = newHtmlElement("img")["src" <=> "image.png"]
    check attrElement0 == $element

    element["alt" <=> "image"]
    check attrElement1 == $element

let complexElement: string = """<div class='centered'><p id='some-text'>Hello!</p></div>"""
test "Element with children and attributes":
    check complexElement == $(
        "div"[
            "p"[
                rawHtmlText "Hello!"
            ]["id" <=> "some-text"]
        ]["class" <=> "centered"]
    )
    check complexElement == $(
        "div"[
            "p"[
                rawXmlText "Hello!"
            ]["id" <=> "some-text"]
        ]["class" <=> "centered"]
    )
