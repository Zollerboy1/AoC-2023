import Foundation
import Helpers

let url = Bundle.module.url(forResource: "day2", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)

let lines = fileContents.split(separator: "\n")

let gamesandcubes = lines.map { line  in
    let a = line.split(separator: ":")
    let game = Int(a[0].split(separator: " ")[1])!
    var red = 0
    var green = 0
    var blue = 0
    for draw in a[1].split(separator: ";") {
        for single in draw.split(separator: ",") {
            let b = single.trimmingCharacters(in: .whitespaces).split(separator: " ")
            let count = Int(b[0])!
            switch b[1] {
                case "blue": if count > blue {
                    blue = count
                }
                case "green": if count > green {
                    green = count
                }
                case "red": if count > red {
                    red = count
                }
                default: fatalError()
            }
        }
    }

    return (game, red, green, blue)
}

let powers = gamesandcubes.map { _, red, green, blue in
    red * green * blue
}

print(powers)
print(powers.reduce(0, +))
