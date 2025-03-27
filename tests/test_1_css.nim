import std/[unittest, strutils]
import cattag

test "Properties":
    check $CssElementProperty(
        property : "border", values: @["solid", "4px", "Red"]
    ) == "border: solid 4px Red;"

const pElement: string = """p {
    color: Black;
    text-align: center;
    border: solid 4px Red;
}"""
const pCondensed: string = """p{color:Black;text-align:center;border:solid 4px Red;}"""
test "Element selectors and condensed elements":
    let element: CssElement = newCssElement("p",
        newCssProperty("color", "Black"),
        newCssProperty("text-align", @["center"]),
        newCssProperty("border", "solid", "4px", "Red")
    )
    check pElement == $element
    check pCondensed == element $ true

const centerClass: string = """.centered {
    text-align: center;
    margin: auto;
}"""
test "Class selectors":
    check centerClass == $newCssClass("centered",
        newCssProperty("text-align", "center"),
        newCssProperty("margin", "auto")
    )

const idSelector: string = """#id {
    background: Red;
}"""
test "ID selectors":
    check idSelector == $newCssId("id",
        newCssProperty("background", "Red")
    )
test "Not duplicate selector prefix":
    check idSelector == $newCssId("#id", # should not add another `#`
        newCssProperty("background", "Red")
    )

const shortComment: string = "/* this is a short comment */"
const longComment: string = """/**
 * This is
 * a long
 * comment!
*/"""
test "Comments":
    check shortComment == $newCssComment("this is a short comment")
    check longComment == $newCssComment(
        "This is",
        "a long",
        "comment!"
    )

const stylesheet: string = """/**
 * Test stylesheet
 * stuff!
*/

html {
    background-color: Black;
}

* {
    color: White;
}

p {
    color: Red;
    text-align: center;
}

/* Classes from now */

.centered {
    text-align: center;
    margin: auto;
}"""
test "Documents":
    var css: CssStylesheet = newCssStylesheet("styles.css")
    css.add(
        newCssComment(
            "Test stylesheet",
            "stuff!"
        ),
        newCssElement("html",
            newCssProperty("background-color", "Black")
        ),
        newCssAll(
            newCssProperty("color", "White")
        ),
        newCssElement("p",
            newCssProperty("color", "Red"),
            newCssProperty("text-align", "center")
        ),
        newCssComment("Classes from now")
    )
    css &= newCssClass("centered",
        newCssProperty("text-align", "center"),
        newCssProperty("margin", "auto")
    )

