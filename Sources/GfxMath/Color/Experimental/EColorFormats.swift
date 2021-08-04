public struct FpRGBColor<D: BinaryFloatingPoint>: EColor {
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

public struct FpRGBAColor<D: BinaryFloatingPoint>: EColor {
    public typealias DataType = D

    public var r: D
    public var g: D
    public var b: D
    public var a: D

    public init(r: D, g: D, b: D, a: D) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    public init(_ r: D, _ g: D, _ b: D, _ a: D) {
        self.init(r: r, g: g, b: b, a: a)
    }
}

extension FpRGBAColor {
    public func toOldColorFormat() -> Color {
        Color(UInt8(max(0, min(255, r * 255))), UInt8(max(0, min(255, g * 255))), UInt8(max(0, min(255, b * 255))), UInt8(max(0, min(255, a * 255))))
    }

    @inlinable mutating public func add(other: Self) {
        self.r += self.r * self.a + other.r * other.a
        self.g += self.g * self.a + other.g * other.a
        self.b += self.b * self.a + other.b * other.a
        self.a += self.a + other.a
    }

    @inlinable mutating public func multiply(other: Self) {
        self.r *= other.r
        self.g *= other.g
        self.b *= other.b
        self.a *= other.a
    }

    @inlinable public static var white: Self {
        Self(1, 1, 1, 1)
    }

    @inlinable public static var black: Self {
        Self(0, 0, 0, 1)
    }

    @inlinable public static var blue: Self {
        Self(0, 0, 1, 1)
    }
}

/*
extension RGBColor where DataType: BinaryInteger {
    public func toOldColorFormat() -> Color where DataType == UInt8 {
        Color(r: r, g: g, b: b, a: 255)
    }

    mutating public func add(other: Self) {
        self.r = DataType(max(0, min(255, Int(self.r) + Int(other.r))))
        self.g = DataType(max(0, min(255, Int(self.g) + Int(other.g))))
        self.b = DataType(max(0, min(255, Int(self.b) + Int(other.b))))
    }

    mutating public func multiply(other: Self) {
        self.r = DataType(max(0, min(255, Int(self.r) * Int(other.r))))
        self.g = DataType(max(0, min(255, Int(self.g) * Int(other.g))))
        self.b = DataType(max(0, min(255, Int(self.b) * Int(other.b))))
    }

    @inlinable public static var white: Self {
        RGBColor(255, 255, 255)
    }

    @inlinable public static var black: Self {
        RGBColor(0, 0, 0)
    }
}*/

public typealias FRGBColor = FpRGBColor<Float>
public typealias DRGBColor = FpRGBColor<Double>

public typealias FRGBAColor = FpRGBAColor<Float>
public typealias DRGBAColor = FpRGBAColor<Double>