import std/[unittest]
import cattag

test "Properties":
    check $CssElementProperty(
        property : "border", values: @["solid", "4px", "Red"]
    ) == "border: solid 4px Red;"

const pElement: string = """p {
    color: Black;
    text-align: center;
    border: solid 4px Red;
}
"""
test "Elements":
    check pElement == $newCssElement("p",
        newCssProperty("color", "Black"),
        newCssProperty("text-align", @["center"]),
        newCssProperty("border", "solid", "4px", "Red")
    )
