import std/[unittest]
import cattag

test "Attributes":
    check $attr("href", "https://www.nirokay.com/") == " href='https://www.nirokay.com/'"
    check $attr("defer") == " defer"
    check $attr("class", "centered", "dark-mode", "urmom") == " class='centered dark-mode urmom'"

test "Elements":
    check $newHtmlElement("tag") == "<tag></tag>"
    check $newHtmlElement("tag", rawHtmlText("hello world")) == "<tag>hello world</tag>"
    check $newHtmlElement("img", rawHtmlText("hello world")) == "<img />"

test "Elements with attributes (with sorting)":
    check $newHtmlElement("img", @[attr("src", "https://www.nirokay.com/favicon.gif"), attr("alt", "Favicon")]) ==
        "<img alt='Favicon' src='https://www.nirokay.com/favicon.gif' />"

test "Elements with children":
    check $newHtmlElement("div",
        newHtmlElement("div",
            newHtmlElement("p", "some text")
        )
    )
