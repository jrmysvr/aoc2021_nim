import solutions/[day1, day2, day3]
import cligen


proc day(number: int) =
    ## Run the solution for a given day
    echo "Running the solution for Day ", $number
    case number:
        of 1:
            echo "Day 1 Part 1"
            echo day1part1()
            echo "Day 1 Part 2"
            echo day1part2()
        of 2:
            echo "Day 2 Part 1"
            echo day2part1()
            echo "Day 2 Part 2"
            echo day2part2()
        of 3:
            echo "Day 3 Part 1"
            echo day3part1()
            echo "Day 3 Part 2"
            echo day3part2()
        else:
            echo "Day number ", number, " is not implemented yet..."

proc all() =
    ## Run all implemented solutions
    echo "Running all solutions!"

    const nDays = 3
    for i in 0..nDays:
        day(i)
        echo ""

when isMainModule:
    echo "AOC 2021 in Nim!"
    #dispatch(main, help= {
    dispatchMulti(
      [day, help = {"number": "Which day's solution to run (1-25)"}],
      [all]
    )
