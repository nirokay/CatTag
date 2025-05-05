import cattag
import ./styles

var html: HtmlDocument = newHtmlDocument("index.html")


# HTML head stuff:
html.addToHead(
    meta("utf-8"), # charset
    meta("viewport", "width=device-width, initial-scale=1"), # viewport
    link("stylesheet", stylesheetName), ## CSS stylesheet

    title(html"More complex HTML and CSS page"), # title
    meta("description", "A bit more complex than the basic example"), # description
)

# HTML body:
html.add( # html.add() and html.addToBody() are equivalent
    main(
        # Header section:
        header(
            h1(html"Very cool cats!"),
            p(html"Here i will show you some really cool cats! :D")
        ),

        # Article section:
        article(
            `div`(@["class" <=> "flex-container", "id" <=> "cat-showcase"],
                section(
                    img("https://www.famousbirthdays.com/faces/crunchy-cat-luna-image.jpg", "Crunchy Luna picture"),
                    h2(
                        html"Luna, a.k.a. ",
                        q("https://www.famousbirthdays.com/people/crunchy-cat-luna.html", "Crunchy Cat")
                    ),
                    p(html(
                        "Super cute and devours food with a loud " &
                        $strong(html"CRUNCH") &
                        "!"
                    ))
                ),
                section(
                    img("https://static.wikia.nocookie.net/floppapedia-revamped/images/a/a4/Unico.jpg/revision/latest", "Uni picture"),
                    h2(
                        html"Unico Uniuni, a.k.a. ",
                        q("https://floppapedia-revamped.fandom.com/wiki/Uni", "Uni")
                    ),
                    p(html(
                        "Why is he looking " & $strong(html"SO SILLY").addattr("class", "animation-shake") & "??!?!???"
                    ))
                )
            )
        ),

        # Footer section:
        footer(
            html"This is the footer :)"
        )
    )
)

html.writeFile()
