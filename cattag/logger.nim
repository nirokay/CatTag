import std/[logging, times, strutils, strformat, os]

const
    cattagLogToConsole* {.booldefine.} = true
    cattagLogToFile* {.booldefine.} = false

    cattagLogFileDirectory* {.strdefine.} = "."
    cattagLogFileName* {.strdefine.} = "cattag.log"
    cattagLogFullPath: string = cattagLogFileDirectory / cattagLogFileName

    prefix: string = "[CatTag] "


proc getTime(): string = now().format("yyyy-MM-dd HH:mm:ss")
proc getPrefix(): string = prefix & "\t[" & getTime() & "]"
proc formatOutput(msg: varargs[string]): string =
    result = getPrefix() & "\n" & msg.join("\n").indent(4)


template withLogger(body: untyped): untyped =
    if not cattagLogToConsole and not cattagLogToFile: return
    when cattagLogToConsole:
        var consoleLogger: Logger = newConsoleLogger(useStderr = true)
        addHandler(consoleLogger)
    when cattagLogToFile:
        var fileLogger: Logger = newFileLogger(cattagLogFullPath)
        addHandler(fileLogger)
    try:
        body
    except CatchableError as e:
        error(getPrefix() & " Failed to log with body with exception " & $e.name & "\n    " & e.msg)
    except Defect as e:
        error(getPrefix() & " Failed to log with body with defect " & $e.name & "\n    " & e.msg)
    finally:
        when cattagLogToConsole: removeHandler(consoleLogger)
        when cattagLogToFile: removeHandler(fileLogger)

proc logFatal*(msg: varargs[string]) =
    ## Thread-save logging for fatal errors
    withLogger: fatal(msg.formatOutput())
    quit QuitFailure
proc logError*(msg: varargs[string]) =
    ## Thread-save logging for errors
    withLogger: error(msg.formatOutput())
proc logWarning*(msg: varargs[string]) =
    ## Thread-save logging for warning
    withLogger: error(msg.formatOutput())
proc logInfo*(msg: varargs[string]) =
    ## Thread-save logging for information
    withLogger: info(msg.formatOutput())


when cattagLogToFile and not cattagLogFileDirectory.dirExists():
    try:
        cattagLogFileDirectory.createDir()
    except CatchableError as e:
        logWarning(&"Could not create directory '{cattagLogFileDirectory}' for logging (Log file '{cattagLogFullPath}')!")
