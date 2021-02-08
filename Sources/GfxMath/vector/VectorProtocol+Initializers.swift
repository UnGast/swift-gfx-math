extension VectorProtocol {
  public init<Other: VectorProtocol>(_ other: Other) where Other.Element == Element {
    self.init(other.elements)
  }
}

extension VectorProtocol where Element: BinaryInteger {
  // TODO: maybe put those two into matrix
  public init<Other: VectorProtocol>(_ other: Other) where Other.Element: BinaryInteger {
    self.init(other.map({ Element.init($0) }))
  }

  public init<Other: VectorProtocol>(_ other: Other) where Other.Element: BinaryFloatingPoint {
    self.init(other.map({ Element.init($0) }))
  }
}

extension VectorProtocol where Element: FloatingPoint {
  // TODO: maybe put those two into matrix
  public init<Other: VectorProtocol>(_ other: Other)
  where Other.Element: BinaryFloatingPoint, Self.Element: BinaryFloatingPoint {
    self.init(other.map(Element.init))
  }

  public init<Other: VectorProtocol>(_ other: Other) where Other.Element: BinaryInteger {
    self.init(other.map(Element.init))
  }
}