import Foundation

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

let indices = Dictionary(uniqueKeysWithValues: maps.keys.sorted(by: { $0.last! != "Z" && $1.last! == "Z" }).enumerated().map { ($0.element, UInt32($0.offset)) })

let map = UnsafeMutablePointer<UInt32>.allocate(capacity: indices.count)
var firstZ = UInt32(indices.count)
for (key, (l, r)) in maps {
    if key.last! == "Z" {
        firstZ = min(firstZ, indices[key]!)
    }
    map[Int(indices[key]!)] = indices[l]! << 16 | indices[r]!
}

let instructionsCount = instructions.count

let count = instructions.withUnsafeBufferPointer { instructionsPointer in
    let instructionsPointer = instructionsPointer.baseAddress.unsafelyUnwrapped
    var start = Array(maps.keys.filter { $0.last! == "A" }.map { indices[$0]! })

    let nodeCount = start.count

    if nodeCount != 6 {
        fatalError()
    }

    return start.withUnsafeMutableBufferPointer { current in
        let current = current.baseAddress.unsafelyUnwrapped
        var start = ContinuousClock.now
        var count = 0
        var instructionCounter = 0
        while true {
            if UInt32(truncatingIfNeeded: count) == 0 {
                let now = ContinuousClock.now
                print(count, ContinuousClock.now - start)
                start = now
            }

            let current0 = current[0]
            let current1 = current[1]
            let current2 = current[2]
            let current3 = current[3]
            let current4 = current[4]
            let current5 = current[5]

            if current0 >= firstZ && current1 >= firstZ && current2 >= firstZ && current3 >= firstZ && current4 >= firstZ && current5 >= firstZ {
                break
            }
            
            if instructionsPointer[instructionCounter] {
                current[0] = map[Int(current0)] & 0xFFFF
                current[1] = map[Int(current1)] & 0xFFFF
                current[2] = map[Int(current2)] & 0xFFFF
                current[3] = map[Int(current3)] & 0xFFFF
                current[4] = map[Int(current4)] & 0xFFFF
                current[5] = map[Int(current5)] & 0xFFFF
            } else {
                current[0] = map[Int(current0)] >> 16
                current[1] = map[Int(current1)] >> 16
                current[2] = map[Int(current2)] >> 16
                current[3] = map[Int(current3)] >> 16
                current[4] = map[Int(current4)] >> 16
                current[5] = map[Int(current5)] >> 16
            }

            count += 1
            instructionCounter = instructionCounter + 1
            if instructionCounter == instructionsCount {
                instructionCounter = 0
            }
        }

        return count
    }
}

print(count)
