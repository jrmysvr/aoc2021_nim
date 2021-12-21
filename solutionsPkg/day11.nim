import std/[strutils, sequtils, sugar, sets]

const puzzleInput = readFile("inputs/day11.txt")
#[
const puzzleInput = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
]#

proc getEnergyLevels(): seq[seq[int]] =
  result = puzzleInput.strip.split('\n').map(line => line.map(l => parseInt($l)))

proc inc(energyLevels: var seq[seq[int]]) =
  var checkFlashes: seq[(int, int)]
  for i in 0..<energyLevels.len():
    for j in 0..<energyLevels[0].len():
      energyLevels[i][j] = (energyLevels[i][j] + 1) mod 10
      if energyLevels[i][j] == 0:
        checkFlashes.add((i, j))

  var tempEnergy: int
  while checkFlashes.len > 0:
    let (i, j) = checkFlashes[0]
    checkFlashes.delete(0..0)
    for di in [-1, 0, 1]:
      for dj in [-1, 0, 1]:
        var
          ix = i + di
          jx = j + dj
        if ix == i and jx == j: continue
        if ix >= 0 and ix < energyLevels.len and jx >= 0 and jx < energyLevels[0].len:
          tempEnergy = energyLevels[ix][jx]
          if tempEnergy == 9:
            checkFlashes.add((ix, jx))
          tempEnergy = if tempEnergy == 0: 0 else: (tempEnergy + 1) mod 10
          energyLevels[ix][jx] = tempEnergy

proc flashCount(energyLevels: seq[seq[int]]): int =
  for i in 0..<energyLevels.len():
    for j in 0..<energyLevels[0].len():
      if energyLevels[i][j] == 0:
        result += 1

proc `$`(energyLevels: seq[seq[int]]): string =
  for line in energyLevels:
    result &= line.join() & '\n'

proc day11part1*(): string =
  var
    levels = getEnergyLevels()
    nSteps = 100
    flashCount = 0
  for step in 1..nSteps:
    levels.inc()
    flashCount += levels.flashCount

  result = $flashCount

proc day11part2*(): string =
  var
    levels = getEnergyLevels()
    step = 0
  while toHashSet(levels.foldl(a.concat(b))).len > 1:
    levels.inc()
    step += 1

  result = $step

when isMainModule:
  echo "Day 11, Part 1"
  echo day11part1()
  echo "Day 11, Part 2"
  echo day11part2()
