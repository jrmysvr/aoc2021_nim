import std/strutils
import std/sequtils
import std/tables
import std/sugar

const puzzleInput = readFile("inputs/day5.txt")

proc parseCoor(coor: string): (int, int) =
  let c = coor.split(',').map(parseInt)
  result = (c[0], c[1])

proc parseLine(line: string): seq[(int, int)] =
  let coors = line.strip.split(" -> ").map(parseCoor)
  assert len(coors) == 2
  let
    left = coors[0]
    right = coors[1]

  var
    (x1, y1) = left
    (x2, y2) = right

  result.add((x1, y1))
  while x1 != x2 or y1 != y2:
    if x1 < x2:
      x1 += 1
    elif x1 > x2:
      x1 -= 1
    if y1 < y2:
      y1 += 1
    elif y1 > y2:
      y1 -= 1

    result.add((x1, y1))

  if result[^1] != right:
    result.add(right)

proc getLines(): seq[seq[(int, int)]] =
  result = puzzleInput.strip.split("\n").map(parseLine)

proc isDiagonal(line: seq[(int, int)]): bool =
  let
    left = line[0]
    right = line[^1]
  return left[0] != right[0] and left[1] != right[1]

proc `$`(ls: seq[seq[(int, int)]]): string =
  var board: seq[seq[string]]
  let maxX: int = ls.foldl(concat(a, b)).map(ab => ab[0]).foldl(max(a, b))
  let maxY: int = ls.foldl(concat(a, b)).map(ab => ab[1]).foldl(max(a, b))

  for y in 0..maxY:
    board.add(@[])
    for _ in 0..maxX:
      board[y].add(".")

  for line in ls:
    for (x, y) in line:
      if board[y][x] == ".":
        board[y][x] = "1"
      else:
        board[y][x] = $(parseInt(board[y][x]) + 1)

  for row in board:
    for col in row:
      result &= col
    result &= '\n'

proc day5part1*(): string =
  var lineTable = initCountTable[(int, int)]()
  var notDiag: seq[seq[(int, int)]]
  for l in getLines():
    if not l.isDiagonal:
      notDiag.add(l)
      for coor in l:
        lineTable.inc(coor)

  var counter = 0
  for coor, count in lineTable.pairs():
    if count > 1:
      counter += 1

  echo $counter

proc day5part2*(): string =
  var lineTable = initCountTable[(int, int)]()
  for l in getLines():
    for coor in l:
      lineTable.inc(coor)

  var counter = 0
  for coor, count in lineTable.pairs():
    if count > 1:
      counter += 1

  echo $counter
