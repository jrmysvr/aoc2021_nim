import std/[osproc, strformat]
from std/os import walkFiles
from std/sequtils import toSeq

proc day(number: int) =
    ## Run the solution for a given day
    echo "Running the solution for Day ", $number
    discard execCmd(fmt"nim c --outDir=build/ -r solutionsPkg/day{number}.nim")
    # discard execCmd(fmt"build/day{number}")

proc all() : bool =
    ## Run all implemented solutions
    echo "Running all solutions!"

    let nDays = toSeq(walkFiles("solutionsPkg/day*.nim")).len
    for i in 1..nDays:
      day(i)

when isMainModule:
    echo "AOC 2021 in Nim!"
    import cligen
    dispatchMulti(
      [day, help = {"number": "Which day's solution to run (1-25)"}],
      [all]
    )
