import Foundation
import Helpers
import Algorithms

let url = Bundle.module.url(forResource: "day7", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")

let cardStrengths: [Character] = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]

struct Hand: Comparable {
    enum Kind: Comparable {
        case high, pair, twoPairs, three, fullHouse, four, five
    }

    let cards: [Character]
    let kind: Kind

    init(_ string: String) {
        self.cards = Array(string)
        var cardCounts = string.grouped { $0 }.mapValues(\.count)
        if let jokerCount = cardCounts["J"] {
            cardCounts["J"] = nil
            if let card = cardCounts.max(by: { a, b in a.1 < b.1 })?.key {
                cardCounts[card]! += jokerCount
            } else {
                cardCounts["J"] = 5
            }
        }
        self.kind = switch cardCounts.count {
            case 1: .five
            case 2: if cardCounts.max(by: { a, b in a.1 < b.1 })!.value == 4 {
                .four
            } else {
                .fullHouse
            }
            case 3: if cardCounts.max(by: { a, b in a.1 < b.1 })!.value == 3 {
                .three
            } else {
                .twoPairs
            }
            case 4: .pair
            default: .high
        }
    }

    static func <(lhs: Hand, rhs: Hand) -> Bool {
        if lhs.kind < rhs.kind {
            return true
        } else if lhs.kind > rhs.kind {
            return false
        }

        return lhs.cards.lexicographicallyPrecedes(rhs.cards) { a, b in cardStrengths.firstIndex(of: a)! < cardStrengths.firstIndex(of: b)! }
    }
}

let handsAndBids = lines.map { line in
    let split = line.split(separator: " ")
    let hand = Hand(String(split[0]))
    let bid = Int(split[1])!
    return (hand, bid)
}.sorted { a, b in a.0 < b.0 }

print(handsAndBids.enumerated().reduce(0) { n, x in n + (x.offset + 1) * x.element.1 })
