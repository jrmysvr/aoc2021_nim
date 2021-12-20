import std/[strutils, sequtils, sugar, algorithm]

const puzzleInput = readFile("inputs/day9.txt")

proc getHeatMap(): seq[seq[int]] =
  result = puzzleInput.strip.split('\n').map(line => line.map(l => $l).map(parseInt))

proc `$`[T](thing: seq[seq[T]]): string =
  for t in thing:
    result &= $t & "\n"

proc isLowPoint(heatMap: seq[seq[int]], rowx, colx: int): bool =
  let
    rowLen = len(heatMap)
    colLen = len(heatMap[0])

  var neighbors: seq[int]
  if rowx - 1 >= 0:
    neighbors.add(heatMap[rowx - 1][colx])
  if rowx + 1 < rowLen:
    neighbors.add(heatMap[rowx + 1][colx])
  if colx - 1 >= 0:
    neighbors.add(heatMap[rowx][colx - 1])
  if colx + 1 < colLen:
    neighbors.add(heatMap[rowx][colx + 1])

  result = heatMap[rowx][colx] < min(neighbors)

proc calcBasinSizeMemo(heatMap: seq[seq[int]], rowx, colx: int, mem: var seq[(int, int)]): int =
  const neighborIxs = @[(-1, 0), (0, -1), (0, 1), (1, 0)]

  let
    rowLen = len(heatMap)
    colLen = len(heatMap[0])

  var
    rx:int
    cx: int

  mem.add((rowx,colx))
  for (dr, dc) in neighborIxs:
    rx = rowx + dr
    cx = colx + dc
    if rx >= 0 and cx >= 0 and rx < rowLen and cx < colLen:
      if heatMap[rx][cx] < 9 and not mem.contains((rx, cx)):
        result += 1 + calcBasinSizeMemo(heatMap, rx, cx, mem)

proc calcBasinSize(heatMap: seq[seq[int]], rowx, colx: int): int =
  var mem: seq[(int, int)]
  result = 1 + calcBasinSizeMemo(heatMap, rowx, colx, mem)

proc day9part1*(): string =
  const heatMap = getHeatMap()
  var risk: int
  for i in 0..<len(heatMap):
    for j in 0..<len(heatMap[0]):
      if heatMap.isLowPoint(i, j):
        risk += (heatMap[i][j] + 1)

  result = $risk

proc day9part2*(): string =
  const heatMap = getHeatMap()
  var basins: seq[int]
  for i in 0..<len(heatMap):
    for j in 0..<len(heatMap[0]):
      if heatMap.isLowPoint(i, j):
        basins.add(calcBasinSize(heatMap, i, j))

  result = $basins.sorted(order = SortOrder.Descending)[0..2].foldl(a*b)

when isMainModule:
  echo "Day 9, Part 1"
  echo day9part1()
  echo "Day 9, Part 2"
  echo day9part2()
