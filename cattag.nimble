# Package

version       = "0.1.7"
author        = "nirokay"
description   = "Static HTML/XML and CSS generator."
license       = "GPL-3.0-only"


# Tasks

import std/[os, strformat]
task assemble, "Assembles all auto-generating modules":
    let
        path: string = "./cattag/auto/generator/"
        srcFile: string = "all.nim"
        gitRepo: string = "https://github.com/mdn/data"
        resources: string = "resources/"
        gitRepoPath: string = path & resources & "data"
    if not dirExists(gitRepoPath):
        exec &"echo \"Cloning git repo\" && cd {path & resources} && git clone \"{gitRepo}\""
    exec &"echo \"Pulling git repo\" && cd {gitRepoPath} && git pull"

    exec &"cd {path} && nim r {srcFile}"

task examples, "Builds all examples":
    let file: string = "pages.nim"
    for kind, path in walkDir("./examples"):
        if kind notin [pcDir, pcLinkToDir]: continue
        if not fileExists(path / file):
            echo &"Invalid structure in dir '{path}'"
            continue
        exec &"cd {path} && nim r {file} && echo \"Finished {path / file}\" || echo \"Failed {path / file}\""


# Dependencies

requires "nim >= 2.2.2"
