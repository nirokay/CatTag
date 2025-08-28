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
        li(html"Luna"),
        li(html"Uni")
    ).setId("id-cat-list")
)

const htmlList: string = """<ul id='id-cat-list'>
    <li>Luna</li>
    <li>Uni</li>
</ul>"""
test "By id":
    let elements: seq[HtmlElement] = html.getElementsById("id-cat-list")
    check elements.len() == 1
    check htmlList == $elements[0]

test "By class":
    let elements: seq[HtmlElement] = html.getElementByClass("class-header")
