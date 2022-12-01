import std/[algorithm,strutils,sequtils]

iterator snackStacks(input: string): int =
    var current = 0
    for line in splitLines(input):
        if isEmptyOrWhitespace(line):
            yield current
            current = 0
        else:
            current += parseInt(line)

let
    input = readAll(stdin)
    stacks = toSeq(snackStacks(input))
    top3 = sorted(stacks, Descending)[0..2]
    sum = foldl(top3, a+b, 0)

echo sum
