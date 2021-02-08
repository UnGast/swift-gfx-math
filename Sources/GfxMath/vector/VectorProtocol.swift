import Foundation

public protocol VectorProtocol: MatrixProtocol {
  associatedtype Dimension: MatrixDimension
}

extension VectorProtocol {
  @inlinable public var description: String {
    return "Vector \(elements)"
  }

  public init(rows: Int) {
    self.init()
    self.rows = rows
  }

  public init(rows: Int, elements: [Element]) {
    self.init()
    self.rows = rows

    for i in 0..<Swift.min(elements.count, self.elements.count) {
      self.elements[i] = elements[i]
    }
  }

  public init(_ elements: [Element]) {
    self.init()
    self.elements = elements
    self.rows = elements.count
  }

  @inlinable public subscript(row: Int) -> Element {
    get {
      return elements[row]
    }

    set {
      elements[row] = newValue
    }
  }

  @inlinable public func clone() -> Self {
    return Self(elements)
  }

  @inlinable public func firstIndex(of element: Element) -> Int? {
    return elements.firstIndex(of: element)
  }

  /// TODO: maybe this function is not needed --> T might be a vector with different Row count than Self
  @inlinable public func asType<T: VectorProtocol>(_ castElement: (_ x: Element) -> T.Element) -> T
  {
    return T(rows: rows, elements: elements.map(castElement))
  }
}

extension VectorProtocol where Element: FloatingPoint {
  @available(*, deprecated, message: "Use .magnitude instead.")
  @inlinable public var length: Element {
    var sum: Element = 0

    for element in self {
      sum += element * element
    }

    return sqrt(sum)
  }

  @inlinable public var magnitude: Element {
    length
  }

  @inlinable public func normalized() -> Self {
    var normalized = Self(rows: rows)

    if length == 0 {
      return normalized
    }

    for i in 0..<rows {
      normalized[i] = self[i] / length
    }

    return normalized
  }

  @inlinable public func rounded() -> Self {
    var result = Self(rows: rows)

    for i in 0..<count {
      result[i] = self[i].rounded()
    }

    return result
  }

  @inlinable public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
    var result = Self(rows: rows)

    for i in 0..<count {
      result[i] = self[i].rounded(rule)
    }

    return result
  }
}

