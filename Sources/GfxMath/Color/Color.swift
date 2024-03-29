import Foundation

public struct Color: Hashable, Equatable {
    public typealias DataType = UInt8

    public typealias RGB<T> = (r: T, g: T, b: T)
    public typealias RGBA<T> = (r: T, g: T, b: T, a: T)
    public typealias HSL = (h: Double, s: Double, l: Double)
    public typealias HSLA = (h: Double, s: Double, l: Double, a: Double)

    public private(set) var rgb: RGB<UInt8>
    /**
    - Returns: color represented by rgb floating point values between 0 and 1
    */
    public func fpRgbZeroOne<T>() -> RGB<T> where T: FloatingPoint {
        (T(rgb.r) / 255, T(rgb.g) / 255, T(rgb.b) / 255)
    }
    /**
    - Returns: color represented by rgba floating point values between 0 and 1
    */
    public func fpRgbaZeroOne<T>() -> RGBA<T> where T: FloatingPoint {
        (T(rgb.r) / 255, T(rgb.g) / 255, T(rgb.b) / 255, T(a) / 255)
    }
    public private(set) var hsl: HSL
    public private(set) var a: UInt8
    public var aFrac: Double {
        Double(a) / 255
    }

    public var r: UInt8 {
        rgb.r
    }
    public var g: UInt8 {
        rgb.g
    }
    public var b: UInt8 {
        rgb.b
    }
    
    public var h: Double {
        hsl.h
    }
    public var s: Double {
        hsl.s
    }
    public var l: Double {
        hsl.l
    }

    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.rgb = RGB(r: r, g: g, b: b)
        self.hsl = Color.rgbToHsl(rgb: RGB(r: r, g: g, b: b))
        self.a = a
    }

    public init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8) {
       self.init(r: r, g: g, b: b, a: a)
    }

    /// - Parameters: all in range 0 - 1
    public init(h: Double, s: Double, l: Double, a: Double) {
        self.hsl = HSL(h: h, s: s, l: l)
        self.rgb = Color.hslToRgb(hsl: HSL(h: h, s: s, l: l))
        self.a = UInt8(a * 255)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(g)
        hasher.combine(b)
        hasher.combine(a)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
    }

    public mutating func adjust(alpha: UInt8) {
        self.a = alpha
    }

    public func adjusted(alpha: UInt8) -> Color {
        var result = self
        result.adjust(alpha: alpha)
        return result
    }

    public func lightened(_ percentage: Double) -> Color {
        Self(h: h, s: s, l: l + l * (percentage / 100), a: Double(a) / 255)
    }

    public func darkened(_ percentage: Double) -> Color {
        Self(h: h, s: s, l: l - l * (percentage / 100), a: Double(a) / 255)
    }

    /// - Parameter otherRelativeAmount: 0-100
    public func mixed(_ other: Color, _ otherRelativeAmout: Double) -> Self {
        let ownFactor = (100 - otherRelativeAmout) / 100
        let otherFactor = otherRelativeAmout / 100
        return Self(
            r: UInt8(Double(r) * ownFactor + Double(other.r) * otherFactor),
            g: UInt8(Double(g) * ownFactor + Double(other.g) * otherFactor),
            b: UInt8(Double(b) * ownFactor + Double(other.b) * otherFactor),
            a: UInt8(Double(a) * ownFactor + Double(other.a) * otherFactor))
    }
}
