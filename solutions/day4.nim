import std/strutils
import std/sequtils
import std/sugar
import std/re

const puzzleInput = readFile("inputs/day4.txt")

type
  Board = object
    size: int
    mat: seq[seq[int]]

  Bingo = object
    numbers: seq[int]
    boards: seq[Board]

proc setupGame(): Bingo =
  let numbers = puzzleInput.strip().split("\n\n")[0].split(',').map(parseInt)
  let boardValuesStr = puzzleInput.strip().split("\n\n")[1..^1]
  var boards: seq[Board]
  for str in boardValuesStr:
    let
      strValues = str.split('\n').map(s => s.strip().replace(re"\s+",
          ".").split('.'))
      size = len(strValues)
      values = strValues.map(row => row.map(parseInt))

    boards.add(Board(size: size, mat: values))

  result = Bingo(numbers: numbers, boards: boards)

proc won(board: Board): bool =
  for row in board.mat:
    if row.foldl(a+b) == -5:
      return true

  for i in 0..<len(board.mat[0]):
    let col = collect:
      for row in board.mat:
        row[i]
    if col.foldl(a+b) == -5:
      return true

proc check(board: var Board, number: int): bool =
  var mat = board.mat
  for i in 0..<len(mat):
    var row = mat[i]
    for j in 0..<len(row):
      if row[j] == number:
        row[j] = -1
        mat[i] = row

    board.mat = mat
  return board.won

proc score(board: Board, winningNumber: int): int =
  let values = collect:
    for row in board.mat:
      for value in row:
        max(value, 0)
  echo $values.foldl(a+b), ", ", winningNumber
  result = values.foldl(a+b)*winningNumber

proc `$`(board: Board): string =
  for row in board.mat:
    result &= $row & "\n"

proc day4part1*(): string =
  var bingo = setupGame()
  result = "No board won..."
  for number in bingo.numbers:
    for i in 0..<len(bingo.boards):
      var board = bingo.boards[i]
      let win = board.check(number)
      if win:
        echo "Bingo!"
        echo $board
        return $board.score(number)

      bingo.boards[i] = board

proc day4part2*(): string =
  var
    bingo = setupGame()
    lastWinIx = 0
    lastWinNum = -1
  for number in bingo.numbers:
    for i in 0..<len(bingo.boards):
      var board = bingo.boards[i]
      if board.won: continue
      let win = board.check(number)
      if win:
        lastWinIx = i
        lastWinNum = number

      bingo.boards[i] = board

  let board = bingo.boards[lastWinIx]
  echo "Bingo!"
  echo $board
  return $board.score(lastWinNum)

when isMainModule:
  echo "Part 1"
  echo day4part1()
  echo "Part 2"
  echo day4part2()
