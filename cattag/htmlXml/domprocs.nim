import std/[strutils]
import types

# ======================== Standardised general procs =========================

# Search by attribute: --------------------------------------------------------

proc getChildrenIfHasAttribute*(element: HtmlElement, searchAttribute: string): seq[HtmlElement] =
    ## Gets an elements children if they have a matching attribute name
    if element.elementType != typeElement: return
    for attribute in element.attributes:
        if attribute.attribute != searchAttribute: continue
        result.add element
        break
    for child in element.children:
        result &= child.getChildrenIfHasAttribute(searchAttribute)

proc getChildrenIfHasAttribute*(elements: seq[HtmlElement], searchAttribute: string): seq[HtmlElement] =
    ## Gets an elements children if they have a matching attribute name
    for element in elements:
        result &= element.getChildrenIfHasAttribute(searchAttribute)

proc getChildrenIfHasAttribute*(document: HtmlDocument, searchAttribute: string): seq[HtmlElement] =
    ## Gets the documents children if they have a matching attribute name
    result = document.body.getChildrenIfHasAttribute(searchAttribute)


# Search by attribute and filter by value: ------------------------------------

proc getChildrenIfHasAttributeAndOneOfValues*(element: HtmlElement, searchAttribute: string, values: seq[string]): seq[HtmlElement] =
    ## Gets an elements children if they have matching attribute name and one of the values
    let list: seq[HtmlElement] = element.getChildrenIfHasAttribute(searchAttribute)
    if list.len() == 0: return

    for elem in list:
        block currentElementSearch:
            for attribute in elem.attributes:
                if attribute.attribute != searchAttribute: continue
                for value in values:
                    if value notin attribute.values: continue
                    result.add elem
                    break currentElementSearch
proc getChildrenIfHasAttributeAndValue*(element: HtmlElement, searchAttribute: string, value: string): seq[HtmlElement] =
    ## Gets an elements children if they have matching attribute name and value
    result = element.getChildrenIfHasAttributeAndOneOfValues(searchAttribute, @[value])

proc getChildrenIfHasAttributeAndOneOfValues*(elements: seq[HtmlElement], searchAttribute: string, values: seq[string]): seq[HtmlElement] =
    ## Gets an elements children if they have matching attribute name and one of the values
    for element in elements:
        result &= element.getChildrenIfHasAttributeAndOneOfValues(searchAttribute, values)
proc getChildrenIfHasAttributeAndValue*(elements: seq[HtmlElement], searchAttribute: string, value: string): seq[HtmlElement] =
    ## Gets an elements children if they have matching attribute name and value
    for element in elements:
        result &= element.getChildrenIfHasAttributeAndOneOfValues(searchAttribute, @[value])

proc getChildrenIfHasAttributeAndOneOfValues*(document: HtmlDocument, searchAttribute: string, values: seq[string]): seq[HtmlElement] =
    ## Gets the documents children if they have matching attribute name and one of the values
    result = document.body.getChildrenIfHasAttributeAndOneOfValues(searchAttribute, values)
proc getChildrenIfHasAttributeAndValue*(document: HtmlDocument, searchAttribute: string, value: string): seq[HtmlElement] =
    ## Gets the documents children if they have matching attribute name and value
    result = document.body.getChildrenIfHasAttributeAndOneOfValues(searchAttribute, @[value])


# Search by tag: --------------------------------------------------------------

proc getChildrenWithTag*(element: HtmlElement, searchTag: string): seq[HtmlElement] =
    ## Gets an elements children that have a matching tag
    if element.elementType != typeElement: return
    for child in element.children:
        if child.elementType != typeElement: continue
        if child.tag == searchTag: result.add child
        result &= child.getChildrenWithTag(searchTag)

proc getChildrenWithTag*(elements: seq[HtmlElement], searchTag: string): seq[HtmlElement] =
    ## Gets an elements children that have a matching tag
    for element in elements:
        result &= element.getChildrenWithTag(searchTag)

proc getChildrenWithTag*(document: HtmlDocument, searchTag: string): seq[HtmlElement] =
    ## Gets the documents children that have a matching tag
    result = document.body.getChildrenWithTag(searchTag)


# =========================== Raw text extraction =============================

proc getChildrenWithText*(element: HtmlElement, searchStrings: seq[string], caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from elements children
    proc modified(str: string): string =
        result = str
        if caseInsensitive: result = result.toLower()

    case element.elementType:
    of typeRawText:
        for rawLine in element.content:
            let line = modified rawLine
            for rawSubstring in searchStrings:
                let substring = modified rawSubstring
                if substring in line: return @[element]
    of typeElement:
        for child in element.children:
            result &= child.getChildrenWithText(searchStrings, caseInsensitive)
    of typeComment:
        return
proc getChildrenWithText*(element: HtmlElement, searchString: string, caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from elements children
    result = element.getChildrenWithText(@[searchString], caseInsensitive)

proc getChildrenWithText*(elements: seq[HtmlElement], searchStrings: seq[string], caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from elements children
    for element in elements:
        result &= element.getChildrenWithText(searchStrings, caseInsensitive)
proc getChildrenWithText*(elements: seq[HtmlElement], searchString: string, caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from elements children
    result = elements.getChildrenWithText(@[searchString], caseInsensitive)

proc getChildrenWithText*(document: HtmlDocument, searchStrings: seq[string], caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from the documents children
    result = document.body.getChildrenWithText(searchStrings, caseInsensitive)
proc getChildrenWithText*(document: HtmlDocument, searchString: string, caseInsensitive: bool = true): seq[HtmlElement] =
    ## Gets all raw html text elements from the documents children
    result = document.body.getChildrenWithText(@[searchString], caseInsensitive)


# =========================== Specific search procs ===========================

# ID: -------------------------------------------------------------------------

proc getElementsById*(element: HtmlElement, id: string): seq[HtmlElement] =
    ## Gets an elements children by id
    result = element.getChildrenIfHasAttributeAndValue("id", id)

proc getElementsById*(elements: seq[HtmlElement], id: string): seq[HtmlElement] =
    ## Gets an elements children by id
    for element in elements:
        result &= element.getElementsById(id)

proc getElementsById*(document: HtmlDocument, id: string): seq[HtmlElement] =
    ## Gets the documents children by id
    result = document.body.getElementsById(id)


# Name: -------------------------------------------------------------------------

proc getElementsByName*(element: HtmlElement, name: string): seq[HtmlElement] =
    ## Gets an elements children by name
    result = element.getChildrenIfHasAttributeAndValue("name", name)

proc getElementsByName*(elements: seq[HtmlElement], name: string): seq[HtmlElement] =
    ## Gets an elements children by name
    for element in elements:
        result &= element.getElementsByName(name)

proc getElementsByName*(document: HtmlDocument, name: string): seq[HtmlElement] =
    ## Gets the documents children by name
    result = document.body.getElementsByName(name)


# Class: -------------------------------------------------------------------------

proc getElementsByClass*(element: HtmlElement, class: string): seq[HtmlElement] =
    ## Gets an elements children by class
    result = element.getChildrenIfHasAttributeAndValue("class", class)

proc getElementsByClass*(elements: seq[HtmlElement], class: string): seq[HtmlElement] =
    ## Gets an elements children by class
    for element in elements:
        result &= element.getElementsByClass(class)

proc getElementsByClass*(document: HtmlDocument, class: string): seq[HtmlElement] =
    ## Gets the documents children by name
    result = document.body.getElementsByClass(class)
