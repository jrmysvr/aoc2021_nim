import std/sequtils
import std/sugar
import system
import strutils
import math

const puzzleInput = readFile("inputs/day3.txt")

proc parseLine(line: string): uint =
  var num: uint
  var i = len(line)
  while i > 0:
    num = cast[uint](parseInt($line[^i]))
    result = result or (num shl (cast[uint](i)-1))
    i -= 1

proc getNBits(num: uint): uint =
  var n = num
  while n >= 1:
    result += 1
    n = n.div(2)

proc getMostCommonBitValue(report: seq[uint], nthBit: uint): uint =
  var
    count0: int
    count1: int
  for number in report:
    if (number and (1'u shl nthBit)) == 0:
      count0 += 1
    else:
      count1 += 1

  return if count0 > count1: 0 else: 1

proc getLeastCommonBitValue(report: seq[uint], nthBit: uint): uint =
  var
    count0: int
    count1: int
  for number in report:
    if (number and (1'u shl nthBit)) == 0:
      count0 += 1
    else:
      count1 += 1

  return if count0 <= count1: 0 else: 1

proc getReport(): seq[uint] =
  const
    input = puzzleInput.strip(chars = {'\n'}).split()
    report = input.map(parseLine)
  result = report

proc day3part1*(): string =
  let
    report = getReport()
    nBits = getNBits(report.foldl(max(a, b)))

  var gammaRate: uint
  for i in 0..<nBits:
    var val = getMostCommonBitValue(report, cast[uint](i))
    gammaRate = gammaRate or (val shl cast[uint](i))

  var epsilonRate: uint = gammaRate xor (2'u^nBits - 1'u)

  result = $(epsilonRate * gammaRate)

proc filterValuesBy(values: seq[uint], f: proc(s: seq[uint],
    nthBit: uint): uint): uint =
  var mValues = values
  let nBits = getNBits(values.foldl(max(a, b)))
  for i in countdown(nBits-1, 0):
    let val = f(mValues, cast[uint](i))
    var indexes: seq[int]
    for ix in 0..<len(mValues):
      if val != ((mValues[ix] shr i) and 1'u):
        indexes.add(ix)
    for ix in countdown(len(indexes)-1, 0):
      let jx = indexes[ix]
      mValues.delete(jx..jx)
      if len(mValues) == 1:
        break
    if len(mValues) == 1:
      break

  result = mValues[0]

proc day3part2*(): string =
  let report = getReport()
  let oxygenGenRate = report.filterValuesBy(getMostCommonBitValue)
  let co2ScrubRate = report.filterValuesBy(getLeastCommonBitValue)

  result = $(co2ScrubRate * oxygenGenRate)

when isMainModule:
  echo "Day3, Part 1"
  echo day3part1()

  echo "Day3, Part 2"
  echo day3part2()
