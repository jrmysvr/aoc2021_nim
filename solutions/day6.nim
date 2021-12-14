import std/strutils
import std/sequtils

const puzzleInput = readFile("inputs/day6.txt")
#const puzzleInput = "3,4,3,1,2"

proc getNearbyFish(): seq[int] =
  result = puzzleInput.strip.split(',').map(parseInt)

proc inNDays(fish: var seq[int], nDays: int) =
  var nFish = 0
  for day in 0..<nDays:
    nFish = fish.len
    for i in 0..<nFish:
      if fish[i] == 0:
        fish.add(8)
        fish[i] = 6
      else:
        fish[i] -= 1


proc day6part1*(): string =
  var fish = getNearbyFish()
  const nDays = 80

  fish.inNDays(nDays)
  result = $fish.len

type
  Node = ref object
    id: int
    value: int
    next: Node

proc day6part2*(): string =
  discard
  #[
  var
    fish = getNearbyFish()
    node = Node(id: 0, value: fish[0])
    nodeId = 1
    currNode: Node

  currNode = node.next
  for f in fish[1..^1]:
    if node.next == nil:
      node.next = Node(id: nodeId, value: f)
      currNode = node.next
    else:
      currNode.next = Node(id: nodeId, value: f)
      currNode = currNode.next

    nodeId += 1

  const nDays = 256
  var
    newNode: Node
    tempNode: Node
  for i in 0..nDays:
    currNode = node
    echo $i, ", ", $currNode.id, ", ", $currNode.value, ", ", $nodeId
    while currNode.next != nil:
      if currNode.value == 0:
        currNode.value = 8
        if newNode == nil:
          newNode = Node(id: nodeId, value: 8)
        elif newNode.next == nil:
          newNode.next = Node(id: nodeId, value: 8)
          tempNode = newNode.next
        else:
          tempNode.next = Node(id: nodeId, value: 8)
          tempNode = tempNode.next
        nodeId += 1
      else:
        currNode.value -= 1
      currNode = currNode.next
    currNode.next = newNode

  result = $nodeId
]#
