import std/[os, strutils]

const resourceDirectory: string = "resources"


type OutputFile* = object
    filename*: string
    lines*: seq[string]

proc newOutputFile*(filename: string): OutputFile = OutputFile(
    filename: filename
)
proc writeFile*(file: OutputFile) =
    writeFile(".." / file.filename, file.lines.join("\n"))


proc fileContent(file: string): string =
    result = readFile(resourceDirectory / file)
proc parseFileLines*(file: string): seq[string] =
    ## Parses file (skips empty lines and comments)
    var content: string = file.fileContent()
    for line in content.split("\n"):
        let formattedLine: string = line.strip()
        if formattedLine == "" or formattedLine.startsWith("#"): continue
        result &= formattedLine
