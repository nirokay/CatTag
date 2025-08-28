const
    # Output directory:
    cattagOutputDirectory* {.strdefine.}: string = "." ## Defines the output directory for HTML, XML and CSS files

    # Html/Xml generation:
    cattagHtmlXmlAttributeQuote* {.strdefine.} = "'" ## Quote used for attribute values (`"` or `'`)
    cattagHtmlXmlSortAttributes* {.booldefine.} = true ## Toggles alphabetical sorting of attributes
    cattagHtmlXmlIndent* {.intdefine.} = 4 ## Sets indent for children (if set to zero, output will be inline)
    cattagHtmlTrailingSlash* {.booldefine.} = true ## Toggles if `br` should generate `<br />` instead of `<br>`
    cattagXmlSelfCloseOnEmptyChildren* {.booldefine.} = true ## Toggles if no children will generate `<some-text />` instead of `<some-text></some-text>` (good practice for XML)
    cattagHtmlGenerateEmptyAttributeValue* {.booldefine.} = false ## Toggles if `<script defer="">...</script>` should be generated instead of `<script defer>...</script>` for HTML

    # Css generation:
    cattagCssIndent* {.intdefine.}: int = 4
