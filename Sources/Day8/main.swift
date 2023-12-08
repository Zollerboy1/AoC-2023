import Foundation
import Helpers

let url = Bundle.module.url(forResource: "day8", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")

let instructions = lines.first!.map { $0 == "R" }

let maps = Dictionary(uniqueKeysWithValues: lines.dropFirst().map { line in 
    let regex = /([A-Z0-9]+) = \(([A-Z0-9]+), ([A-Z0-9]+)\)/
    let match = line.firstMatch(of: regex)!
    let from = match.1
    let to = (match.2, match.3)
    return (from, to)
})

let starts = Array(maps.keys.filter { $0.last! == "A" })

let counts = starts.map { start in
    var current = start
    var count = 0
    while current.last! != "Z" {
        let instruction = instructions[count % instructions.count]
        if instruction {
            current = maps[current]!.1
        } else {
            current = maps[current]!.0
        }
        count += 1
    }
    return count
}

print(counts.lcm())
