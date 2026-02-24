import std/[unittest]
import cattag

test "Properties":
    check "color: Red;" == $("color" := "Red")
    check "border: solid 4px Blue;" == $("border" := @["solid", "4px", "Blue"])

const pElement: string = """p {
    background: Black;
    color: White;
    text-align: center;
}"""
test "Elements":
    check pElement == $"p"{
        "background" := "Black",
        "color" := "White",
        "text-align" := "center"
    }

const someClassString: string = """.some-class {
    display: block;
}"""
test "Classed HTML elements":
    let
        someClass: CssElement = ".some-class"{
            "display" := "block"
        }
        someClassClassic: CssElement = newCssClass("some-class",
            "display" := "block"
        )
    check someClassString == $someClass
    check someClassString == $someClassClassic

    let element: HtmlElement = p(html "Hello world").setClass(someClass)
    check $element == "<p class='some-class'>Hello world</p>"
