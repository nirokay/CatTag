import std/[unittest, strutils]
import cattag

var html: HtmlDocument = newHtmlDocument("index.html")
html.addToHead(
    title(html"Index page!")
)
html.add(
    h1(html"Welcome to my page").setClass("class-header"),
    p(html"Welcome! Feel free to explore here"),

    h2(html"My favourite internet cats").setClass("class-header"),
    ul(
        li(html"Silly cat Luna").setValue("silly crunchy cat"),
        li(html"Silly cat Uni").setValue("silly judgemental cat")
    ).setId("id-cat-list")
)

const htmlList: string = """<ul id='id-cat-list'>
    <li value='silly crunchy cat'>Silly cat Luna</li>
    <li value='silly judgemental cat'>Silly cat Uni</li>
</ul>"""
test "By id":
    let elements: seq[HtmlElement] = html.getElementsById("id-cat-list")
    check elements.len() == 1
    check htmlList == $elements[0]

const htmlHeaders: string = """<h1 class='class-header'>Welcome to my page</h1>
<h2 class='class-header'>My favourite internet cats</h2>"""
test "By class":
    let elements: seq[HtmlElement] = html.getElementsByClass("class-header")
    check elements.len() == 2
    check htmlHeaders == $elements

const
    htmlListItemLuna: string = "<li value='silly crunchy cat'>Silly cat Luna</li>"
    htmlListItemUni: string = "<li value='silly judgemental cat'>Silly cat Uni</li>"
    htmlListItems: string = [htmlListItemLuna, htmlListItemUni].join("\n")
test "By tag":
    let elements: seq[HtmlElement] = html.getChildrenWithTag("li")
    check elements.len() == 2
    check htmlListItems == $elements
test "By has attribute":
    let elements: seq[HtmlElement] = html.getChildrenIfHasAttribute("value")
    check elements.len() == 2
    check htmlListItems == $elements
test "By has attribute and value":
    let elements: seq[HtmlElement] = html.getChildrenIfHasAttributeAndValue("value", "silly crunchy cat")
    check elements.len() == 1
    check htmlListItemLuna == $elements

let htmlRawText: string = """Silly cat Luna
Silly cat Uni"""
test "By substring in raw html text":
    let noElements: seq[HtmlElement] = html.getChildrenWithText("silly", false)
    check noElements.len() == 0

    let elements: seq[HtmlElement] = html.getChildrenWithText("silly")
    check elements.len() == 2
    let text: string = block:
        var r: seq[string]
        for element in elements:
            r.add element.content.join("\n")
        r.join("\n")
    check htmlRawText == text
