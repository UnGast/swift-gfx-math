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
