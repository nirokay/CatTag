import cattag

const stylesheetName*: string = "styles.css"
var css: CssStylesheet = newCssStylesheet(stylesheetName)

const
    colourBackgroundDark*: CssColor = newCssColor("#161820")
    colourBackgroundMiddle*: CssColor = newCssColor("#22242B")
    colourText*: CssColor = newCssColor("#E7E5E2")

    roundedCorners*: CssElementProperty = borderRadius := 15'px
    insetPadding*: CssElementProperty = padding := 10'px
    outsetMargin*: CssElementProperty = margin := 10'px

    classAnimationShake*: CssElement = ".animation-shake"{
        animationName := "shake",
        animationDuration := 0.35's,
        animationIterationCount := "infinite",
        fontSize := 2'em,
        position := "relative"
    }

css.add(
    # Elements:
    "html"{
        backgroundColor := colourBackgroundDark,
        color := colourText
    },

    "header > *"{
        textAlign := CssPosition.center,
    },
    "section"{
        backgroundColor := colourBackgroundMiddle,
        roundedCorners,
        insetPadding,
        outsetMargin
    },
    "footer"{
        position := "fixed",
        left := 0,
        bottom := -20'px,
        width := 100'percent,
        height := 50'px,
        backgroundColor := colourBackgroundMiddle,
        insetPadding
    },

    "img"{
        maxWidth := 200'px,
        maxHeight := 200'px,
        display := `block`,
        roundedCorners
    },

    "h1, h2, h3"{
        textDecoration := "underline",
        textDecorationStyle := "wavy"
    },

    "strong"{
        fontSize := 1.2'em
    },

    # Classes:
    ".flex-container"{
        display := flex,
        justifyContent := CssContentPosition.center,
        flexWrap := "wrap"
    },

    # Animations:
    classAnimationShake,
    "@keyframes shake"{
        "0%"{
            left := -10'px,
            top := -10'px
        },
        "12%"{
            left := 0'px,
            top := 0'px
        },
        "25%"{
            left := 10'px,
            top := 10'px
        },
        "37%"{
            left := 0'px,
            top := 0'px
        },
        "50%"{
            left := 10'px,
            top := -10'px
        },
        "62%"{
            left := 0'px,
            top := 0'px
        },
        "75%"{
            left := -10'px,
            top := 10'px
        },
        "87%"{
            left := 0'px,
            top := 0'px
        },
        "100%"{
            left := -10'px,
            top := -10'px
        },
    }
)

css.writeFile()
