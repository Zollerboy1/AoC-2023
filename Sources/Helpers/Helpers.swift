extension Array {
    public func sum() -> Element where Element: AdditiveArithmetic {
        return reduce(.zero, +)
    }

    public func product() -> Element where Element: Numeric {
        return reduce(1, *)
    }

    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try filter(predicate).count
    }

    public func count(of element: Element) -> Int where Element: Equatable {
        return count(where: { $0 == element })
    }

    public func lcm() -> Element where Element: BinaryInteger {
        return reduce(1, lcm(_:_:))
    }
}

public func gcd<T: BinaryInteger>(_ x: T, _ y: T) -> T {
    var (x, y) = (x, y)
    while y > 0 {
       (x, y) = (y, x % y)
    }

    return x
}

public func lcm<T: BinaryInteger>(_ x: T, _ y: T) -> T {
    return if x > y {
        (x / gcd(x, y)) * y
    } else {
        (y / gcd(x, y)) * x
    }
}

public func lcm<T: BinaryInteger>(_ ts: T...) -> T {
    return ts.lcm()
}
