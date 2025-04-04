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

let attrElement: string = """<div class='centered'>
    <p id='some-text'>
        Hello!
    </p>
</div>"""
test "Element with children and attributes":
    check attrElement == $(
        "div"[
            "p"[
                rawHtmlText "Hello!"
            ]["id" <=> "some-text"]
        ]["class" <=> "centered"]
    )
