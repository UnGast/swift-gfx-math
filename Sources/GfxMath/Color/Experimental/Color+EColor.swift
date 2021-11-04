extension Color: ERGBColor {
  public func toOldColorFormat() -> Color {
    self
  }

  public mutating func add(other: Self) {
    fatalError("cannot modify Color")
  }

  public mutating func multiply(other: Self) {
    fatalError("cannot modify Color")
  }
}