const
    voidElementTags*: seq[string] = @[
        "area",
        "base",
        "br",
        "col",
        "embed",
        "hr",
        "img",
        "input",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr",

        # Legacy:
        "command",
        "keygen",
        "menuitem",
        "frame"
    ] ## Reference: http://xahlee.info/js/html5_non-closing_tag.html
