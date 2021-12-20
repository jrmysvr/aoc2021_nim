import std/[strutils, sequtils, sugar, tables]

const puzzleInput = readFile("inputs/day7.txt")
#const puzzleInput = "16,1,2,0,4,2,7,1,2,14"

proc getCrabPositions(): seq[int] =
  result = puzzleInput.strip.split(',').map(parseInt)

proc day7part1*(): string =
  const
    positions = getCrabPositions()
  var fuel = positions.foldl(a + b)
  for pos in min(positions)..max(positions):
    fuel = min(fuel, positions.map(p => abs(p - pos)).foldl(a + b))

  result = $fuel

var cache = initTable[int, int]()
proc f(num: int) : int =
  if not cache.hasKey(num):
    for i in 0..num:
      result += i

    cache[num] = result
  else:
    result = cache[num]

proc day7part2*(): string =
  const
    positions = getCrabPositions()
  var fuel = high(int)
  for pos in min(positions)..max(positions):
    fuel = min(fuel, positions.map(p => f(abs(p - pos))).foldl(a + b))

  result = $fuel


when isMainModule:
  echo "Day 7, Part 1"
  echo day7part1()
  echo "Day 7, Part 2"
  echo day7part2()
