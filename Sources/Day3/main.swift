import Foundation
import Helpers

let url = Bundle.module.url(forResource: "day3", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")

let grid = lines.map {
    Array($0)
}

var nextToSymbol = Array(repeating: Array(repeating: false, count: grid[0].count), count: grid.count)

func markAdjacentDigits(_ x: Int, _ y: Int, _ toLeft: Bool) -> Int {
    guard (toLeft && y > 0) || (!toLeft && y < grid[0].count - 1) else {
        return y
    }

    let newY = toLeft ? y - 1 : y + 1

    if grid[x][newY].isWholeNumber {
        nextToSymbol[x][newY] = true
        return markAdjacentDigits(x, newY, toLeft)
    } else {
        return y
    }
}

var sum = 0
var gearsSum = 0

for (i, row) in grid.enumerated() {
    for (j, tile) in row.enumerated() {
        if !(tile.isWholeNumber || tile == ".") {
            var nums = [Int]()
            for x in max(0, i - 1)...min(grid.count - 1, i + 1) {
                for y in max(0, j - 1)...min(grid[0].count - 1, j + 1) {
                    if grid[x][y].isWholeNumber {
                        let newNumber = !nextToSymbol[x][y]

                        nextToSymbol[x][y] = true
                        let start = markAdjacentDigits(x, y, true)
                        let end = markAdjacentDigits(x, y, false)

                        if newNumber {
                            nums.append(Int(String(grid[x][start...end]))!)
                        }
                    }
                }
            }

            sum += nums.reduce(0, +)

            if tile == "*" && nums.count == 2 {
                gearsSum += nums[0] * nums[1]
            }
        }
    }
}

print(sum)
print(gearsSum)
