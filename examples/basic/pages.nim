import cattag

var html: HtmlDocument = newHtmlDocument("index.html")

html.add(
    h1(html"Cats"),
    p(html"Cool stuff about cats."),
    h2(html"Facts"),
    ul(
        li(html"cats are cool!"),
        li(html"cats are the best")
    )
)

html.writeFile()
