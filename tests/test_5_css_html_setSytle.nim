import std/[unittest]
import cattag

const stringified: string = """<p style='color: Red; background-color: Black;'>Hello world!</p>"""

test "Sequences":
    check stringified == $p(html"Hello world!").setStyle(@[
        color := Red,
        backgroundColor := Black
    ])
test "Varargs":
    check stringified == $p(html"Hello world!").setStyle(
        color := Red,
        backgroundColor := Black
    )
