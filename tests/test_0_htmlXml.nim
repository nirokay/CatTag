import std/[unittest, strutils]
import cattag

test "Attributes":
    check $attr("href", "https://www.nirokay.com/") == " href='https://www.nirokay.com/'"
    check $attr("defer", true) == " defer"
    check $attr("defer") == " defer"
    check $attr("class", "centered", "dark-mode", "urmom") == " class='centered dark-mode urmom'"

test "Raw text":
    check $rawHtmlText("hello world") == "hello world"

const shortComment: string = """<!--
    hello world
--->"""
const longComment: string = """<!--
    hello world
    how are you?
--->"""
const longerComment: string = """<!--
    even
    longer
    now
--->"""
const longestComment: string = """<!--
    WOAH
    SO
    LONG
    COMMENT
--->"""

test "HTML Comments":
    check $newHtmlComment("hello world") == shortComment
    check $newHtmlComment("hello world", "how are you?") == longComment
    check $newHtmlComment("even", "longer", "now") == longerComment
    check $newHtmlComment("WOAH", "SO", "LONG", "COMMENT") == longestComment

test "Xml Comments":
    check $newXmlComment("hello world") == shortComment
    check $newXmlComment("hello world", "how are you?") == longComment
    check $newXmlComment("even", "longer", "now") == longerComment
    check $newXmlComment("WOAH", "SO", "LONG", "COMMENT") == longestComment

const elementWithContent: string = """<tag>
    hello world
</tag>"""
test "Elements":
    check $newHtmlElement("tag") == "<tag></tag>"
    check $newXmlElement("tag") == "<tag />"
    # Raw text:
    check $newHtmlElement("tag", rawHtmlText("hello world")) == elementWithContent
    check $newHtmlElement("tag", "hello world") == elementWithContent
    check $newHtmlElement("img", rawHtmlText("hello world")) == "<img />"

    check $newXmlElement("tag", "hello world") == elementWithContent
    check $newXmlElement("img", "hello world") == elementWithContent.replace("tag", "img")

test "Elements with attributes (with sorting)":
    check $newHtmlElement("img", @[attr("src", "https://www.nirokay.com/favicon.gif"), attr("alt", "Favicon")]) ==
        "<img alt='Favicon' src='https://www.nirokay.com/favicon.gif' />"
    check $newXmlElement("img", @[attr("src", "https://www.nirokay.com/favicon.gif"), attr("alt", "Favicon")]) ==
        "<img alt='Favicon' src='https://www.nirokay.com/favicon.gif' />"
