import std/[strutils, sequtils, options, algorithm]

const puzzleInput = readFile("inputs/day10.txt")
#[
const puzzleInput = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""
]#

type
  Stack[T] = object
    values: seq[T]
    head: T

proc push[T](stack: var Stack[T], value: T) =
  stack.values.add(value)
  stack.head = value

proc pop[T](stack: var Stack[T]): T =
  result = stack.values[^1]
  stack.head = stack.values[^1]
  stack.values.delete(stack.values.len-1)

proc empty[T](stack: var Stack[T]): bool =
  result = stack.values.len == 0

proc matches(left: char, right: char): bool =
  var expected: char
  case left:
    of '<':
      expected = '>'
    of '[':
      expected = ']'
    of '(':
      expected = ')'
    of '{':
      expected = '}'
    else: discard
  result = right == expected

proc getNavigationSubsystem(): seq[string] =
  result = puzzleInput.strip.split('\n')

proc validate(line: string): (bool, Option[char]) =
  var stack: Stack[char]
  var bracket: char
  for l in line:
    case l:
      of '[', '(', '{', '<':
        stack.push(l)
      else:
        if stack.empty(): return (false, none(char))
        bracket = stack.pop()
        if not bracket.matches(l):
          return (false, some(l))

  return (true, none(char))

proc getUnmatchedIn(line: string): seq[char] =
  var stack: Stack[char]
  var bracket: char
  for l in line:
    case l:
      of '[', '(', '{', '<':
        stack.push(l)
      else:
        if stack.empty(): return @[]
        bracket = stack.pop()
        if not bracket.matches(l):
          stack.push(bracket)
          return stack.values

  return stack.values

proc day10part1*(): string =
  var
    score = 0
    isValid = false
    invalidChar = none(char)

  for line in getNavigationSubsystem():
    (isValid, invalidChar) = line.validate()
    if isValid:
      continue
    case invalidChar.get():
      of ')':
        score += 3
      of ']':
        score += 57
      of '}':
        score += 1197
      of '>':
        score += 25137
      else: discard

  result = $score

proc day10part2*(): string =
  var
    score: int
    scores: seq[int]
    unmatched: seq[char]
    bracket: char
    isValid = false
    ignored = none(char)

  for line in getNavigationSubsystem():
    (isValid, ignored) = line.validate()
    if not isValid:
      continue
    score = 0
    unmatched = getUnmatchedIn(line)
    for i in countdown(len(unmatched)-1, 0):
      bracket = unmatched[i]
      score *= 5
      case bracket:
        of '(':
          score += 1
        of '[':
          score += 2
        of '{':
          score += 3
        of '<':
          score += 4
        else: discard
    scores.add(score)

  let middle = len(scores) div 2
  result = $scores.sorted()[middle]


when isMainModule:
  echo "Day 10, Part 1"
  echo day10part1()
  echo "Day 10, Part 2"
  echo day10part2()
