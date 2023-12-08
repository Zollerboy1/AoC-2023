import Foundation
import Helpers
import Algorithms
import SE0270_RangeSet

extension Range where Bound: AdditiveArithmetic {
    init(start: Bound, count: Bound) {
        self = start..<(start + count)
    }
}

let start = ContinuousClock.now

let url = Bundle.module.url(forResource: "day5", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let sections = fileContents.split(separator: "\n\n")

let seeds = sections[0]
    .drop { $0 != ":" }
    .dropFirst()
    .split(separator: " ")
    .map { Int($0)! }
    .chunks(ofCount: 2)
    .map { Range(start: $0.first!, count: $0.last!) }

let maps = sections[1...].map { section in 
    section.split(separator: "\n")[1...].map { line in 
        let numbers = line.split(separator: " ").map { Int($0)! }
        return (Range(start: numbers[1], count: numbers[2]), numbers[0])
    }
}

let locations = maps.reduce(RangeSet(seeds)) { (ranges, map) in
    var ranges = ranges
    var newRanges = RangeSet<Int>()
    for (from, to) in map {
        let intersection = ranges.intersection(RangeSet(from))
        ranges.remove(contentsOf: from)
        
        for range in intersection.ranges {
            newRanges.insert(contentsOf: Range(start: to + (range.lowerBound - from.lowerBound), count: range.count))
        }
    }

    newRanges.formUnion(ranges)

    return newRanges
}

print(locations.ranges.first!.lowerBound)

let end = ContinuousClock.now
print(start.duration(to: end).formatted(.units(allowed: [.milliseconds, .microseconds])))
