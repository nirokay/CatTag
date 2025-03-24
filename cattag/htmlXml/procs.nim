import std/[sequtils]
import types


# Elements: -------------------------------------------------------------------

template newElement(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(tag: string, attributes: seq[Attribute]): OBJECT_TYPE =
        ## Constructs new `OBJECT_TYPE`
        result = OBJECT_TYPE(tag: tag, attributes: attributes)
    proc PROC_NAME*(tag: string, attributes: seq[Attribute], children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new `OBJECT_TYPE`
        result = OBJECT_TYPE(tag: tag, attributes: attributes, children: children)
    proc PROC_NAME*(tag: string, attributes: seq[Attribute], children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new `OBJECT_TYPE`
        result = PROC_NAME(tag, attributes, children.toSeq())
    proc PROC_NAME*(tag: string, children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new `OBJECT_TYPE`
        result = OBJECT_TYPE(tag: tag, children: children)
    proc PROC_NAME*(tag: string, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new `OBJECT_TYPE`
        result = OBJECT_TYPE(tag: tag, children: children.toSeq())

newElement(newHtmlElement, HtmlElement)
newElement(newXmlElement, XmlElement)


template addChildren(PROC_NAME, OBJECT_TYPE: untyped): untyped =
    proc PROC_NAME*(element: var OBJECT_TYPE, children: seq[OBJECT_TYPE]) =
        ## Appends children to `OBJECT_TYPE`
        element.children &= children
    proc PROC_NAME*(element: OBJECT_TYPE, children: seq[OBJECT_TYPE]): OBJECT_TYPE =
        ## Appends children to `OBJECT_TYPE`
        result = element
        result.children &= children
    proc PROC_NAME*(element: var OBJECT_TYPE, children: varargs[OBJECT_TYPE]) =
        ## Appends children to `OBJECT_TYPE`
        element.children &= children.toSeq()
    proc PROC_NAME*(element: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Appends children to `OBJECT_TYPE`
        result = element
        result.children &= children.toSeq()

addChildren(add, HtmlElement)
addChildren(add, XmlElement)


template addAttribute(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(element: var OBJECT_TYPE, attributes: seq[Attribute]) =
        ## Adds attributes to `OBJECT_TYPE`
        element.attributes &= attributes
    proc PROC_NAME*(element: OBJECT_TYPE, attributes: seq[Attribute]): OBJECT_TYPE =
        ## Adds attributes to `OBJECT_TYPE`
        result = element
        result.attributes &= attributes
    proc PROC_NAME*(element: var OBJECT_TYPE, attributes: varargs[Attribute]) =
        ## Adds attributes to `OBJECT_TYPE`
        element.attributes &= attributes.toSeq()
    proc PROC_NAME*(element: OBJECT_TYPE, attributes: varargs[Attribute]): OBJECT_TYPE =
        ## Adds attributes to `OBJECT_TYPE`
        result = element
        result.attributes &= attributes.toSeq()

addAttribute(add, HtmlElement)
addAttribute(add, XmlElement)


# Documents: ------------------------------------------------------------------

template newDocument(PROC_NAME: untyped, OBJECT_TYPE: typedesc): untyped =
    proc PROC_NAME*(filename: string): OBJECT_TYPE =
        ## Creates new `OBJECT_TYPE` document with file nme
        result = OBJECT_TYPE(file: filename)

newDocument(newHtmlDocument, HtmlDocument)
newDocument(newXmlDocument, XmlDocument)


template addToDocument(PROC_NAME, LOCATION: untyped, OBJECT_TYPE, CHILD_TYPE: typedesc): untyped =
    proc PROC_NAME*(document: var OBJECT_TYPE, children: seq[CHILD_TYPE]) =
        document.LOCATION &= children
    proc PROC_NAME*(document: OBJECT_TYPE, children: seq[CHILD_TYPE]): OBJECT_TYPE =
        result = document
        result.LOCATION &= children
    proc PROC_NAME*(document: var OBJECT_TYPE, children: varargs[CHILD_TYPE]) =
        document.LOCATION &= children.toSeq()
    proc PROC_NAME*(document: OBJECT_TYPE, children: varargs[CHILD_TYPE]): OBJECT_TYPE =
        result = document
        result.LOCATION.add children.toSeq()
addToDocument(addToHead, head, HtmlDocument, HtmlDocumentElement)
addToDocument(addToBody, body, HtmlDocument, HtmlDocumentElement)
addToDocument(add, body, HtmlDocument, HtmlDocumentElement)

addToDocument(addToBody, body, XmlDocument, XmlDocumentElement)
addToDocument(add, body, XmlDocument, XmlDocumentElement)
