/// Represents color as components from 0 to 255 (for all integer types, even when max value is higher).
public struct IRGBColor<D: BinaryInteger>: ERGBColor {
  public typealias DataType = D

  public var r: D
  public var g: D
  public var b: D

  public init(r: D, g: D, b: D) {
    self.r = r
    self.g = g
    self.b = b
  }
}

extension IRGBColor {
  public func toOldColorFormat() -> Color {
    Color(UInt8(max(0, min(255, r))), UInt8(max(0, min(255, g))), UInt8(max(0, min(255, b))), 255)
  }

  public mutating func add(other: Self) {
    r = D(min(255, max(0, Int(r) + Int(other.r))))
    g = D(min(255, max(0, Int(g) + Int(other.g))))
    b = D(min(255, max(0, Int(b) + Int(other.b))))
  }

  public mutating func multiply(other: Self) {
    r = D(min(255, max(0, Int(r) * Int(other.r))))
    g = D(min(255, max(0, Int(g) * Int(other.g))))
    b = D(min(255, max(0, Int(b) * Int(other.b))))
  }

  public static var white: Self { 
    Self(r: 255, g: 255, b: 255)
  }

  public static var black: Self {
    Self(r: 0, g: 0, b: 0)
  }
}

public typealias UI8RGBColor = IRGBColor<UInt8>
public typealias IntRGBColor = IRGBColor<Int>