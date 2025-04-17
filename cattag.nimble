# Package

version       = "0.1.0"
author        = "nirokay"
description   = "Static HTML/XML and CSS generator."
license       = "GPL-3.0-only"
srcDir        = "cattag"


# Tasks

import std/[strformat]
task assemble, "Assembles all auto-generating modules":
    let
        path: string = "./cattag/auto/generator/"
        srcFile: string = "all.nim"
    exec &"cd {path} && nim r {srcFile}"


# Dependencies

requires "nim >= 2.2.2"
