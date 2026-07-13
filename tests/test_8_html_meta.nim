import std/[unittest]
import cattag

test "Meta elements":
    check $metaKeywords(@["website", "stuff", "here"]) == "<meta content='website, stuff, here' name='keywords' />"

test "OG elements":
    check $ogTitle("website") == "<meta content='website' property='og:title' />"
    check $ogType("website") == "<meta content='website' property='og:type' />"
    check $ogImage("image.png") == "<meta content='image.png' property='og:image' />"
    check $ogImageAlt("bla bla") == "<meta content='bla bla' property='og:image:alt' />"

test "Twitter card":
    check $twitterCard() == "<meta content='summary_large_image' property='twitter:card' />"
    check $twitterTitle("bla bla") == "<meta content='bla bla' property='twitter:title' />"
