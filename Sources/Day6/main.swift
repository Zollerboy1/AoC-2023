import Foundation
import Helpers

let url = Bundle.module.url(forResource: "day6", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")
let splitLines = lines.map { $0.drop { $0 != ":" }.dropFirst().split(separator: " ").map { Int($0)! } }

let races = zip(splitLines[0], splitLines[1])

let result = races.map { time, distance in
    var count = 0
    for holdTime in 0...time {
        if (time - holdTime) * holdTime > distance {
            count += 1
        }
    }
    return count
}.reduce(1, *)

let race = lines.map { String($0.drop { $0 != ":" }.dropFirst().filter { $0 != " " }) }.prefix(2).map { Int($0)! }

print(race[0])
var count = 0
for holdTime in 0...race[0] {
    if holdTime % 1000000 == 0 {
        print(holdTime)
    }
    if (race[0] - holdTime) * holdTime > race[1] {
        count += 1
    }
}

print(result)
print(count)
