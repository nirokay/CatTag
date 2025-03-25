import std/[sequtils]
import types


# Attributes: -----------------------------------------------------------------

template newAttr(PROC_NAME: untyped): untyped =
    proc PROC_NAME*(attribute: string, values: seq[string]): Attribute =
        ## Constructs new `Attribute`
        result = Attribute(attribute: attribute, values: values)
    proc PROC_NAME*(attribute: string, values: varargs[string]): Attribute =
        ## Constructs new `Attribute`
        result = Attribute(attribute: attribute, values: values.toSeq())

newAttr(newAttribute)
newAttr(attr)


# Raw text: -------------------------------------------------------------------

template newRawText(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(content: string): OBJECT_TYPE =
        ## Constructs raw text for document
        result = OBJECT_TYPE(elementType: typeRawText, content: @[content])
    proc PROC_NAME*(content: seq[string]): OBJECT_TYPE =
        ## Constructs raw text for document
        result = OBJECT_TYPE(elementType: typeRawText, content: content)
    proc PROC_NAME*(content: varargs[string]): OBJECT_TYPE =
        ## Constructs raw text for document
        result = OBJECT_TYPE(elementType: typeRawText, content: content.toSeq())

newRawText(rawHtmlText, HtmlElement)
newRawText(rawXmlText, XmlElement)


# Elements: -------------------------------------------------------------------

template newElement(PROC_NAME: untyped, RAW_TEXT_PROC: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(tag: string): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag)
    proc PROC_NAME*(tag: string, attributes: seq[Attribute]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, attributes: attributes)

    proc PROC_NAME*(tag: string, attributes: seq[Attribute], children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, attributes: attributes, children: children)

    proc PROC_NAME*(tag: string, attributes: seq[Attribute], child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, attributes: attributes, children: @[child] & children.toSeq())
    proc PROC_NAME*(tag: string, children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, children: children)
    proc PROC_NAME*(tag: string, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, children: @[child] & children.toSeq())

    proc PROC_NAME*(tag: string, content: seq[string]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, children: @[RAW_TEXT_PROC(content)])
    proc PROC_NAME*(tag: string, content: string, moreContent: varargs[string]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, children: @[RAW_TEXT_PROC(@[content] & moreContent.toSeq())])

newElement(newHtmlElement, rawHtmlText, HtmlElement)
newElement(newXmlElement, rawXmlText, XmlElement)


template newComment(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(comment: seq[string]): OBJECT_TYPE =
        ## Constructs new comment
        result = OBJECT_TYPE(elementType: typeComment, comment: comment)
    proc PROC_NAME*(comment: varargs[string]): OBJECT_TYPE =
        ## Constructs new comment
        result = OBJECT_TYPE(elementType: typeComment, comment: comment.toSeq())

newComment(newHtmlComment, HtmlElement)
newComment(newXmlComment, XmlElement)


template addChildren(PROC_NAME, OBJECT_TYPE: untyped): untyped =
    proc PROC_NAME*(element: var OBJECT_TYPE, children: seq[OBJECT_TYPE]) =
        ## Appends children to element
        element.children &= children
    proc PROC_NAME*(element: OBJECT_TYPE, children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Appends children to element
        result = element
        result.children &= children
    proc PROC_NAME*(element: var OBJECT_TYPE, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]) =
        ## Appends children to element
        element.children &= @[child] & children.toSeq()
    proc PROC_NAME*(element: OBJECT_TYPE, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Appends children to element
        result = element
        result.children &= @[child] & children.toSeq()

addChildren(add, HtmlElement)
addChildren(add, XmlElement)


template addAttribute(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(element: var OBJECT_TYPE, attributes: seq[Attribute]) =
        ## Adds attributes to element
        element.attributes &= attributes
    proc PROC_NAME*(element: OBJECT_TYPE, attributes: seq[Attribute]): OBJECT_TYPE =
        ## Adds attributes to element
        result = element
        result.attributes &= attributes
    proc PROC_NAME*(element: var OBJECT_TYPE, attribute: Attribute, attributes: varargs[Attribute]) =
        ## Adds attributes to element
        element.attributes &= @[attribute] & attributes.toSeq()
    proc PROC_NAME*(element: OBJECT_TYPE, attribute: Attribute, attributes: varargs[Attribute]): OBJECT_TYPE =
        ## Adds attributes to element
        result = element
        result.attributes &= @[attribute] & attributes.toSeq()

addAttribute(add, HtmlElement)
addAttribute(add, XmlElement)


# Documents: ------------------------------------------------------------------

template newDocument(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(filename: string): OBJECT_TYPE =
        ## Creates new document with file name
        result = OBJECT_TYPE(file: filename)
    proc PROC_NAME*(): OBJECT_TYPE =
        ## Creates new document with without file name
        ##
        ## Will raise `IOError` when writing file to disk and no name was provided
        result = OBJECT_TYPE()

newDocument(newHtmlDocument, HtmlDocument)
newDocument(newXmlDocument, XmlDocument)


template writeDocument(OBJECT_TYPE: typedesc): untyped =
    proc writeFile*(document: OBJECT_TYPE, filename: string) =
        ## Writes document to disk
        ##
        ## Raises `IOError` when not able to write to disk
        filename.writeFile($document)
    proc writeFile*(document: OBJECT_TYPE) =
        ## Writes document to disk
        ##
        ## Raises `IOError` when `file` field is empty or could not write to disk
        if unlikely document.file == "": raise IOError.newException("Document 'file' field is empty.")
        document.file.writeFile($document)

writeDocument(HtmlDocument)
writeDocument(XmlDocument)


template addToDocument(PROC_NAME, LOCATION: untyped, OBJECT_TYPE, CHILD_TYPE: typedesc): untyped =
    proc PROC_NAME*(document: var OBJECT_TYPE, children: seq[CHILD_TYPE]) =
        document.LOCATION &= children
    proc PROC_NAME*(document: OBJECT_TYPE, child: CHILD_TYPE, children: seq[CHILD_TYPE]): OBJECT_TYPE =
        result = document
        result.LOCATION &= @[child] & children
    proc PROC_NAME*(document: var OBJECT_TYPE, child: CHILD_TYPE, children: varargs[CHILD_TYPE]) =
        document.LOCATION &= @[child] & children.toSeq()
    proc PROC_NAME*(document: OBJECT_TYPE, child: CHILD_TYPE, children: varargs[CHILD_TYPE]): OBJECT_TYPE =
        result = document
        result.LOCATION.add @[child] & children.toSeq()
addToDocument(addToHead, head, HtmlDocument, HtmlElement)
addToDocument(addToBody, body, HtmlDocument, HtmlElement)
addToDocument(add, body, HtmlDocument, HtmlElement)

addToDocument(addToBody, body, XmlDocument, XmlElement)
addToDocument(add, body, XmlDocument, XmlElement)
