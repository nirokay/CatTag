import cattag

var html: HtmlDocument = newHtmlDocument("index.html")

html.add(
    h1(html"Custom output directory"),
    p(
        html"This file has been written into the",
        code(html cattagOutputDirectory),
        html"subdirectory!"
    ),
    p(
        html"Look at the",
        code(html"nim.cfg"),
        html"file!"
    )
)

html.writeFile()
