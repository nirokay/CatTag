import std/[os, strutils]

const resourceDirectory: string = "resources"

proc fileContent(file: string): string =
    result = readFile(resourceDirectory / file)

proc parseFileLines*(file: string): seq[string] =
    var content: string = file.fileContent()
    for line in content.split("\n"):
        let formattedLine: string = line.strip()
        if formattedLine == "" or formattedLine.startsWith("#"): continue
        result &= formattedLine
