import Foundation
import Helpers
import Algorithms

let url = Bundle.module.url(forResource: "day4", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")

let cards = lines.map { line in
    let numbers = line.drop { $0 != ":" }.dropFirst().split(separator: "|")
    let winning = Set(numbers[0].split(separator: " "))
    let myNumbers = Set(numbers[1].split(separator: " "))

    return winning.intersection(myNumbers).count
}

var counts = Array(repeating: 1, count: cards.count)
for (i, card) in cards.enumerated() {
    for j in (i + 1)..<(i + card + 1) {
        counts[j] += counts[i]
    }
}

print(cards.map { 1 << ($0 - 1) }.reduce(0, +))
print(counts.reduce(0, +))
