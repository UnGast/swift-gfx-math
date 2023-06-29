public struct FpRGBColor<D: BinaryFloatingPoint>: ERGBColor {
    public typealias DataType = D

    public var r: D
    public var g: D
    public var b: D

    public init(r: D, g: D, b: D) {
        self.r = r
        self.g = g
        self.b = b
    }

    public init(_ r: D, _ g: D, _ b: D) {
        self.init(r: r, g: g, b: b)
    }
}

extension FpRGBColor {
    public func toOldColorFormat() -> Color {
        Color(UInt8(max(0, min(255, r * 255))), UInt8(max(0, min(255, g * 255))), UInt8(max(0, min(255, b * 255))), 255)
    }

    public func toIRGB<D2: BinaryInteger>() -> IRGBColor<D2> {
        IRGBColor(
            r: D2(max(0, min(255, r * 255))),
            g: D2(max(0, min(255, g * 255))),
            b: D2(max(0, min(255, b * 255)))
        )
    }

    @inlinable mutating public func add(other: Self) {
        self.r += other.r
        self.g += other.g
        self.b += other.b
    }

    @inlinable mutating public func multiply(other: Self) {
        self.r *= other.r
        self.g *= other.g
        self.b *= other.b
    }

    @inlinable public static var white: Self {
        Self(1, 1, 1)
    }

    @inlinable public static var black: Self {
        Self(0, 0, 0)
    }

    @inlinable public static var blue: Self {
        Self(0, 0, 1)
    }
}

public typealias FRGBColor = FpRGBColor<Float>
public typealias DRGBColor = FpRGBColor<Double>