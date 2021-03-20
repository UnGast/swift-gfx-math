import Foundation

public protocol VectorProtocol: MatrixProtocol {
  associatedtype Dimension: MatrixDimension

  init(_ elements: [Element])
}

extension VectorProtocol {
  @inlinable public var description: String {
    return "Vector \(elements)"
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
    return T(elements.map(castElement))
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
    var normalized = self

    if length == 0 {
      return normalized
    }

    for i in 0..<rows {
      normalized[i] = self[i] / length
    }

    return normalized
  }

  @inlinable public func rounded() -> Self {
    var result = self

    for i in 0..<count {
      result[i] = self[i].rounded()
    }

    return result
  }

  @inlinable public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
    var result = self

    for i in 0..<count {
      result[i] = self[i].rounded(rule)
    }

    return result
  }
}

