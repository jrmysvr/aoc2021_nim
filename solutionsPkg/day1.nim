import std/strutils
from std/sequtils import map

const inputDay1 = readFile("inputs/day1.txt")

proc getDepthsData(): seq[int] =
    return inputDay1.strip(chars = {'\n'}).split('\n').map(parseInt)

proc day1part1*(): string =
    ## Count the number of increases between a depth and the subsequent depth
    let depths = getDepthsData()
    var
        lastDepth = depths[0]
        increaseCount = 0

    # The first depth doesn't increase - skip it
    for depth in depths[1..^1]:
        if depth > lastDepth:
            increaseCount += 1
        lastDepth = depth

    result = $increaseCount

proc day1part2*(): string =
    ## Count the number of increased 3-measurement windows
    let depths = getDepthsData()

    var
        lastMeasurement = 0
        increaseCount = 0
        measurement = 0

    # The first window doesn't increase - skip it
    for i in 3..depths.len-3:
        measurement = depths[i] + depths[i+1] + depths[i+2]
        if measurement > lastMeasurement:
            increaseCount += 1
        lastMeasurement = measurement

    result = $increaseCount
