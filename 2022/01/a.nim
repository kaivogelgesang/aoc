import std/strutils
import std/strformat

var globalMax = 0
var current = 0

for line in splitLines(readAll(stdin)):
    if isEmptyOrWhitespace(line):
        globalMax = max(globalMax, current)
        current = 0
    else:
        current += parseInt(line)

echo &"global maximum: {globalMax}"