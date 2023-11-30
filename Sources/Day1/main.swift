import Foundation
import Algorithms
import Collections
import Numerics
import SwiftGraph
import BigInt

let url = Bundle.module.url(forResource: "day1", withExtension: "txt")!
let fileContents = try! String(contentsOf: url, encoding: .utf8)


let lines = fileContents.split(separator: "\n")