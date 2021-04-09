/// experimental
public protocol EColor {
    func toOldColorFormat() -> Color
    mutating func add(other: Self)
    mutating func multiply(other: Self)

    static var white: Self { get }
    static var black: Self { get }
}

extension EColor {
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        lhs.add(other: rhs)
    }

    @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
        var result = lhs
        result += rhs
        return result
    }

    @inlinable public static func *= (lhs: inout Self, rhs: Self) {
        lhs.multiply(other: rhs)
    }

    @inlinable public static func * (lhs: Self, rhs: Self) -> Self {
        var result = lhs
        result *= rhs
        return result
    }
}