import Foundation
import Helpers

let url = Bundle.module.url(forResource: "day1", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")

let numberWords = [
    "one", 
    "two", 
    "three", 
    "four", 
    "five", 
    "six", 
    "seven", 
    "eight", 
    "nine"
]

var numbers = [Int]()
for line in lines {
    var firstNumber = 0
    var index = line.startIndex
    first: while index != line.endIndex {
        for (i, word) in numberWords.enumerated() {
            if line[index...].starts(with: word) {
                firstNumber = i + 1
                break first
            }
        }

        if line[index].isNumber {
            firstNumber = Int(String(line[index]))!
            break
        }

        index = line.index(after: index)
    }

    var lastNumber = 0
    index = line.endIndex
    last: while index != line.startIndex {
        index = line.index(before: index)

        for (i, word) in numberWords.enumerated() {
            if line[index...].starts(with: word) {
                lastNumber = i + 1
                break last
            }
        }

        if line[index].isNumber {
            lastNumber = Int(String(line[index]))!
            break
        }
    }

    numbers.append(firstNumber * 10 + lastNumber)
}

print(numbers.reduce(0, +))
