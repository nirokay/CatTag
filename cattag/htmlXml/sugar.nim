import std/[strutils, sequtils]
import types, procs


proc `<=>`*(attribute: string, values: seq[string]): Attribute =
    ## Sugar constructor for `Attribute`
    result = newAttribute(attribute, values)
proc `<=>`*(attribute: string, values: varargs[string]): Attribute =
    ## Sugar constructor for `Attribute`
    result = attribute <=> values.toSeq()


template newBrackets(OBJECT_TYPE: typedesc): untyped =
    proc `[]`*(tag: string, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Constructs new element
        result = OBJECT_TYPE(elementType: typeElement, tag: tag, children: @[child] & children.toSeq())
    proc `[]`*(element: var OBJECT_TYPE, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]) =
        ## Assigns children to element
        element.children = @[child] & children.toSeq()
    proc `[]`*(element: var OBJECT_TYPE, attribute: Attribute, attributes: varargs[Attribute]) =
        ## Assigns children to element
        element.attributes.add @[attribute] & attributes.toSeq()
    proc `[]`*(element: OBJECT_TYPE, child: OBJECT_TYPE, children: varargs[OBJECT_TYPE]): OBJECT_TYPE =
        ## Assigns children to element
        result = element
        result.children = @[child] & children.toSeq()
    proc `[]`*(element: OBJECT_TYPE, attribute: Attribute, attributes: varargs[Attribute]): OBJECT_TYPE =
        ## Assigns children to element
        result = element
        result.attributes.add @[attribute] & attributes.toSeq()

newBrackets(HtmlElement)
newBrackets(XmlElement)
