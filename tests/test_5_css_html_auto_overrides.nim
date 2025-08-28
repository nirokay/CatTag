import std/[unittest]
import cattag

const
    styleShort: string = """<p style='color: Red;'>Hello world!</p>"""
    styleLong: string = """<p style='color: Red; background-color: Black;'>Hello world!</p>"""

test "Style - Single":
    check styleShort == $p(html"Hello world!").setStyle(
        color := Red
    )

test "Style - Sequences":
    check styleLong == $p(html"Hello world!").setStyle(@[
        color := Red,
        backgroundColor := Black
    ])
test "Style - Varargs":
    check styleLong == $p(html"Hello world!").setStyle(
        color := Red,
        backgroundColor := Black
    )


const
    classShort: string = """<p class='cat'>meow</p>"""
    classLong: string = """<p class='cat purring'>mrrp meow</p>"""

    classCat: CssElement = newCssClass("cat",
        "noise" := "meow"
    )
    classPurring: CssElement = newCssClass("purring",
        "noise" := "mrrp !important" # idk lol, this is silly :3
    )

test "Class - Single":
    check classShort == $p(html"meow").setClass(classCat)
test "Class - Sequences":
    check classLong == $p(html"mrrp meow").setClass(@[classCat, classPurring])
test "Class - Varargs":
    check classLong == $p(html"mrrp meow").setClass(classCat, classPurring)
