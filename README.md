# CatTag

> [!WARNING]
> This project is still in heavy development.

## About

A static HTML/XML and CSS generator from Nim code. For cats (humans are tolerated).

This is the successor to [my other/old HTML/XML/CSS generator **websitegenerator**](https://github.com/nirokay/websitegenerator/)
rewritten (more like reimplemented with major changes, so like, idk how you would call that... remade?) and enhanced.

## Installation

Include the following line in your `.nimble` file: `requires "https://github.com/nirokay/CatTag"`

## Examples

Feel free to explore [the examples subdirectory](./examples/)!

### Basic example

This is a very basic example, only showing off HTML generation.

```nim
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
```
```html
<!DOCTYPE html>
<html>
    <head></head>
    <body>
        <h1>Cats</h1>
        <p>Cool stuff about cats.</p>
        <h2>Facts</h2>
        <ul>
            <li>cats are cool!</li>
            <li>cats are the best</li>
        </ul>
    </body>
</html>
```

## Roadmap

### Planned features

* [x] HTML/XML Generation
* [x] CSS Generation
* [x] HTML/XML sugar syntax
* [x] CSS sugar syntax
* [x] HTML QoL attribute constants (`class`, `lang`, `id`, ...)
* [x] HTML QoL procs (`p("text")` for `newHtmlElement("p", "text")`)
* [x] CSS QoL property constants (`text-align`, `background-color`, ...)
* [ ] CSS QoL property and property value constants (`center`, `Red`, ...)
* [x] CSS QoL procs
* [x] DOM procs
* [ ] `HtmlElement.style` field stuff (usage similar to typescript element style manipulation)

### Distant future ideas

* [ ] HTML/XML Parsing
* [ ] CSS Parsing

## License

This project is licenced under the GPL-3.0 license.
