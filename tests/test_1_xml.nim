import std/[unittest]
import cattag


const elementWithChildren: string = """<cat>
    <name>Lucy</name>
    <fur length='short'>
        <colours>
            <colour>Black</colour>
            <colour>Brown</colour>
            <colour>Beige</colour>
        </colours>
    </fur>
    <favourite-snacks>
        <snack favourite>
            Tuna
        </snack>
    </favourite-snacks>
    <missing-data />
</cat>"""

test "Elements with children":
    let element: XmlElement = newXmlElement("cat",
        newXmlElement("name", "Lucy"),
        newXmlElement("fur", @[attr("length", "short")],
            newXmlElement("colours",
                newXmlElement("colour", "Black"),
                newXmlElement("colour", "Brown"),
                newXmlElement("colour", "Beige")
            )
        ),
        newXmlElement("favourite-snacks",
            newXmlElement("snack", @[attr("favourite")], "Tuna")
        ),
        newXmlElement("missing-data")
    )

const xmlDocument: string = """<?xml version='1.0' encoding='utf-8'?>
<cats>
    <cat>
        <name>
            Lucy
        </name>
        <fur length='short'>
            Brown
            Black
            Beige
        </fur>
        <favourite-patting-spots>
            <pat-spot favourite='true'>
                Head
            </pat-spot>
            <pat-spot>
                Back
            </pat-spot>
        </favourite-patting-spots>
    </cat>
    <cat>
        <name>
            Findus
        </name>
        <fur length='short'>
            White
            Brown
        </fur>
        <favourite-patting-spots />
    </cat>
</cats>"""

test "Documents":
    let document: XmlDocument = newXmlDocument("cats.xml").add(
        newXmlElement("cats",
            newXmlElement("cat",
                newXmlElement("name", "Lucy"),
                newXmlElement("fur", @[attr("length", "short")], "Brown", "Black", "Beige"),
                newXmlElement("favourite-patting-spots",
                    newXmlElement("pat-spot", @[attr("favourite", "true")], "Head"),
                    newXmlElement("pat-spot", "Back")
                )
            ),
            newXmlElement("cat",
                newXmlElement("name", "Findus"),
                newXmlElement("fur", @[attr("length", "short")], "White", "Brown"),
                newXmlElement("favourite-patting-spots")
            )
        )
    )
    check xmlDocument == $document
