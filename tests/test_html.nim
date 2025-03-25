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
test "Comments":
    check $newHtmlComment("hello world") == htmlComment
    check $newHtmlComment("hello world", "how are you?") == longHtmlComment

test "Elements":
    check $newHtmlElement("tag") == "<tag></tag>"
    # Raw text:
    check $newHtmlElement("tag", rawHtmlText("hello world")) == "<tag>hello world</tag>"
    check $newHtmlElement("tag", "hello world") == "<tag>hello world</tag>"
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
