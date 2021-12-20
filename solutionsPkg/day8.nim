import std/[strutils, sequtils, tables, sugar, enumerate, math, sets]

const puzzleInput = readFile("inputs/day8.txt")
#[
const puzzleInput = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""
]#

proc getSignalValues(): (seq[seq[string]], seq[seq[string]]) =
  const
    inputLines = puzzleInput.strip.split('\n')
    signal = inputLines.map(line => line.split(" | ")[0].split(' '))
    output = inputLines.map(line => line.split(" | ")[1].split(' '))
  result = (signal, output)

proc valueToDigit(value: string): int =
  case len(value):
    of 2:
      result = 1
    of 3:
      result = 7
    of 4:
      result = 4
    of 7:
      result = 8
    else:
      result = -1

type
  ValueConverter = object
    setTable: Table[int, HashSet[char]]
    bitTable: Table[int, int]

proc charToBit(ch: char): int =
  var shift: int
  case ch:
    of 'a':
      shift = 0
    of 'b':
      shift = 1
    of 'c':
      shift = 2
    of 'd':
      shift = 3
    of 'e':
      shift = 4
    of 'f':
      shift = 5
    of 'g':
      shift = 6
    else: discard

  result = 1 shl shift

proc oneCount(num: int, nbits: int = 7): int =
  for i in 0..<7:
    result += (num shr i) and 1

proc initValueConverter(signalValues: seq[string]): ValueConverter =
  result = ValueConverter()
  var bitValue: int
  for value in signalValues:
    bitValue = 0
    for v in value:
      bitValue = bitValue or charToBit(v)
    result.setTable[bitValue] = toHashSet(value)

  let
    bitValues: seq[int] = toSeq(result.setTable.keys())
    one = bitValues.filter(b => b.oneCount == 2)[0]
    four = bitValues.filter(b => b.oneCount == 4)[0]
    seven = bitValues.filter(b => b.oneCount == 3)[0]
    eight = bitValues.filter(b => b.oneCount == 7)[0]
    six = bitValues.filter(b => b.oneCount == 6 and (b and one).oneCount == 1)[0]
    top = one xor seven
    topRight = (one and six) xor one
    five = bitValues.filter(b => b.oneCount == 5 and (b xor six).oneCount == 1)[0]
    nine = bitValues.filter(b => b.oneCount == 6 and (b xor topRight) == five)[0]
    bottom = nine xor four xor top
    bottomLeft = nine xor eight
    tempMiddle = bitValues.filter(b => b.oneCount == 5 and (b xor bottom xor top xor one).oneCount == 1)
    middle = tempMiddle[0] xor one xor bottom xor top
    two = (top or middle or bottom or bottomLeft or topRight)
    three = (top or middle or bottom or one)
    zero = eight xor middle

  result.bitTable[zero] = 0
  result.bitTable[one] = 1
  result.bitTable[two] = 2
  result.bitTable[three] = 3
  result.bitTable[four] = 4
  result.bitTable[five] = 5
  result.bitTable[six] = 6
  result.bitTable[seven] = 7
  result.bitTable[eight] = 8
  result.bitTable[nine] = 9

proc convert(valueConverter: ValueConverter, value: string): int =
  var bitValue = 0
  for v in value:
    bitValue = bitValue or charToBit(v)

  result = valueConverter.bitTable.getOrDefault(bitValue, -1)

proc day8part1*(): string =
  var
    digit: int
    digitCounts = initCountTable[int]()
  const (_, outputValues) = getSignalValues()
  for values in outputValues:
    for value in values:
      digit = valueToDigit(value)
      if digit in [1, 4, 7, 8]:
        digitCounts.inc(digit)

  result = $toSeq(digitCounts.values).foldl(a + b)

proc day8part2*(): string =
  var
    digit: int
    tempDigit: int
    output: int
  const (signalValues, outputValues) = getSignalValues()
  for (signals, outputs) in zip(signalValues, outputValues):
    digit = 0
    var valueConverter = initValueConverter(signals)
    for (i, value) in enumerate(outputs):
      tempDigit = valueConverter.convert(value)
      digit += tempDigit * (10 ^ (len(outputs) - i - 1))
    output += digit

  result = $output

when isMainModule:
  echo "Day 8, Part 1"
  echo day8part1()
  echo "Day 8, Part 2"
  echo day8part2()
