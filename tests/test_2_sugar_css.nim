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

