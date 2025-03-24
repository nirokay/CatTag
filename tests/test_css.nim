import std/[unittest]
import cattag

test "CSS Properties":
    check $CssElementProperty(
        property : "border", values: @["solid", "4px", "Red"]
    ) == "border: solid 4px Red;"
