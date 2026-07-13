import ../types, ../procs, ../sugar
import std/[strutils]

proc meta(): HtmlElement = newHtmlElement("meta")

# Common meta tags:

proc metaCharset*(content: string = "UTF-8"): HtmlElement = meta().add(
    "charset" <=> content
)

proc metaTitle*(content: string): HtmlElement = meta().add(
    "name" <=> "title",
    "content" <=> content
)
proc metaDescription*(content: string): HtmlElement = meta().add(
    "name" <=> "description",
    "content" <=> content
)
proc metaAuthor*(content: string): HtmlElement = meta().add(
    "name" <=> "author",
    "content" <=> content
)

proc metaKeywords*(content: string): HtmlElement = meta().add(
    "name" <=> "keywords",
    "content" <=> content
)
proc metaKeywords*(content: seq[string], joinedBy: string = ", "): HtmlElement = metaKeywords(content.join(joinedBy))

proc metaViewport*(content: string): HtmlElement = meta().add(
    "name" <=> "viewport",
    "content" <=> content
)
proc metaViewport*(width: string, initialScale: float): HtmlElement = meta().add(
    "name" <=> "viewport",
    "content" <=> "width=" & width & ", initial-scale=" & $initialScale
)

# OG stuff:

proc og*(property, content: string): HtmlElement = meta().add(
    "property" <=> (if not property.startsWith("og:"): "og:" & property else: property),
    "content" <=> content
) ## Open Graph Protocol Element (https://ogp.me/)
proc ogSub(property, subProperty, content: string): HtmlElement = og(property & ":" & subProperty, content)

proc ogTitle*(content: string): HtmlElement = og("title", content) ## OG title
proc ogDescription*(content: string): HtmlElement = og("description", content) ## OG description
proc ogUrl*(content: string): HtmlElement = og("url", content) ## OG url
proc ogSecureUrl*(content: string): HtmlElement = og("secure_url", content) ## OG secure url
proc ogType*(content: string): HtmlElement = og("type", content) ## OG type
proc ogLocale*(content: string): HtmlElement = og("locale", content) ## OG locale
proc ogLocaleAlt*(content: string): HtmlElement = og("locale:alternate", content) ## OG alternate locale
proc ogSiteName*(content: string): HtmlElement = og("site_name", content) ## OG site name
proc ogDeterminer*(content: string): HtmlElement = og("determiner", content) ## OG determiner

proc subImage(sub, content: string): HtmlElement = ogSub("image", sub, content)
proc ogImage*(content: string): HtmlElement = og("image", content) ## OG image
proc ogImageUrl*(content: string): HtmlElement = subImage("url", content) ## OG url (same as `ogImage`)
proc ogImageSecureUrl*(content: string): HtmlElement = subImage("secure_url", content) ## OG image secure url
proc ogImageType*(content: string): HtmlElement = subImage("type", content) ## OG image type
proc ogImageWidth*(content: string): HtmlElement = subImage("width", content) ## OG image width
proc ogImageHeight*(content: string): HtmlElement = subImage("height", content) ## OG image height
proc ogImageAlt*(content: string): HtmlElement = subImage("alt", content) ## OG image alternate text

proc subVideo(sub, content: string): HtmlElement = ogSub("video", sub, content)
proc ogVideo*(content: string): HtmlElement = og("video", content) ## OG video
proc ogVideoUrl*(content: string): HtmlElement = subVideo("url", content) ## OG url (same as `ogVideo`)
proc ogVideoSecureUrl*(content: string): HtmlElement = subVideo("secure_url", content) ## OG video secure url
proc ogVideoType*(content: string): HtmlElement = subVideo("type", content) ## OG video type
proc ogVideoWidth*(content: string): HtmlElement = subVideo("width", content) ## OG video width
proc ogVideoHeight*(content: string): HtmlElement = subVideo("height", content) ## OG video height
proc ogVideoAlt*(content: string): HtmlElement = subVideo("alt", content) ## OG video alternate text

proc subAudio(sub, content: string): HtmlElement = ogSub("audio", sub, content)
proc ogAudio*(content: string): HtmlElement = og("audio", content) ## OG audio
proc ogAudioSecureUrl*(content: string): HtmlElement = subAudio("secure_url", content) ## OG audio secure url
proc ogAudioType*(content: string): HtmlElement = subAudio("type", content) ## OG audio type


proc subArticle(sub, content: string): HtmlElement = ogSub("article", sub, content)
proc ogArticle*(content: string): HtmlElement = og("article", content)
proc ogArticlePublishedTime*(content: string): HtmlElement = subArticle("published_time", content)
proc ogArticleModifiedTime*(content: string): HtmlElement = subArticle("modified_time", content)
proc ogArticleExpirationTime*(content: string): HtmlElement = subArticle("expiration_time", content)
proc ogArticleAuthor*(content: string): HtmlElement = subArticle("author", content)
proc ogArticleSection*(content: string): HtmlElement = subArticle("section", content)
proc ogArticleTag*(content: string): HtmlElement = subArticle("tag", content)

proc subBook(sub, content: string): HtmlElement = ogSub("book", sub, content)
proc ogBook*(content: string): HtmlElement = og("book", content)
proc ogBookAuthor*(content: string): HtmlElement = subBook("author", content)
proc ogBookIsbn*(content: string): HtmlElement = subBook("isbn", content)
proc ogBookReleaseDate*(content: string): HtmlElement = subBook("release_date", content)
proc ogBookTag*(content: string): HtmlElement = subBook("tag", content)


# Twitter card:

proc twitter*(name, content: string): HtmlElement = meta().add(
    "property" <=> (if not name.startsWith("twitter:"): "twitter:" & name else: name),
    "content" <=> content
) ## Twitter Cards (https://web.archive.org/web/20220426194124/https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/markup)

proc twitterCard*(): HtmlElement = twitter("card", "summary_large_image")
proc twitterSite*(content: string): HtmlElement = twitter("site", content)
proc twitterSiteId*(content: string): HtmlElement = twitter("site:id", content)
proc twitterCreator*(content: string): HtmlElement = twitter("creator", content)
proc twitterDescription*(content: string): HtmlElement = twitter("description", content)
proc twitterTitle*(content: string): HtmlElement = twitter("title", content)
proc twitterImage*(content: string): HtmlElement = twitter("image", content)
proc twitterImageAlt*(content: string): HtmlElement = twitter("image:alt", content)
proc twitterPlayer*(content: string): HtmlElement = twitter("player", content)
proc twitterPlayerWidth*(content: string): HtmlElement = twitter("player:width", content)
proc twitterPlayerHeight*(content: string): HtmlElement = twitter("player:height", content)
proc twitterPlayerStream*(content: string): HtmlElement = twitter("player:stream", content)
proc twitterAppNameIphone*(content: string): HtmlElement = twitter("app:name:iphone", content)
proc twitterAppIdIphone*(content: string): HtmlElement = twitter("app:id:iphone", content)
proc twitterAppUrlIphone*(content: string): HtmlElement = twitter("app:url:iphone", content)
proc twitterAppNameIpad*(content: string): HtmlElement = twitter("app:name:ipad", content)
proc twitterAppIdIpad*(content: string): HtmlElement = twitter("app:id:ipad", content)
proc twitterAppUrlIpad*(content: string): HtmlElement = twitter("app:url:ipad", content)
proc twitterAppNameGooglePlay*(content: string): HtmlElement = twitter("app:name:googleplay", content)
proc twitterAppIdGooglePlay*(content: string): HtmlElement = twitter("app:id:googleplay", content)
proc twitterAppUrlGooglePlay*(content: string): HtmlElement = twitter("app:url:googleplay", content)
