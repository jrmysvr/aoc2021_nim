import strutils
import sequtils
import strformat

const inputDay2 = readFile("inputs/day2.txt")

type
  Submarine = object
    position: int
    depth: int
    aim: int

proc newSubmarine(): Submarine =
  result = Submarine(position: 0, depth: 0, aim: 0)

proc move(sub: var Submarine, direction: string, distance: int,
    withAim: bool = false) =
  case direction:
    of "forward":
      sub.position += distance
      if withAim:
        sub.depth += (sub.aim * distance)
    of "backward":
      sub.position -= distance
    of "down":
      if withAim:
        sub.aim += distance
      else:
        sub.depth += distance
    of "up":
      if withAim:
        sub.aim -= distance
      else:
        sub.depth -= distance

proc `$`(sub: Submarine): string =
  result = fmt"Submarine(position={sub.position}, depth={sub.depth})"

proc lineToMovement(line: string): (string, int) =
  let temp = line.split(' ')
  return (temp[0], temp[1].parseInt)

proc getCourse(): seq[(string, int)] =
  return inputDay2.strip(chars = {'\n'}).split('\n').map(lineToMovement)

proc day2part1*(): string =
  let course = getCourse()
  var submarine = newSubmarine()
  for _, (direction, distance) in course:
    submarine.move(direction, distance)

  echo $submarine
  result = $(submarine.position * submarine.depth)

proc day2part2*(): string =
  let course = getCourse()
  var submarine = newSubmarine()
  for _, (direction, distance) in course:
    submarine.move(direction, distance, withAim = true)

  echo $submarine
  result = $(submarine.position * submarine.depth)


