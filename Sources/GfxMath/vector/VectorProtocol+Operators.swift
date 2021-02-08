extension VectorProtocol {
  @inlinable public func dot(_ otherVector: Self) -> Element {
    var result = Element.zero
    for i in 0..<count {
      result += self[i] * otherVector[i]
    }
    return result
  }

  @inlinable public static func - (lhs: Self, rhs: Self) -> Self {
    let rows = Swift.max(lhs.rows, rhs.rows)
    var resultVector = Self(rows: rows)

    for i in 0..<Swift.min(lhs.rows, rhs.rows) {
      resultVector[i] = lhs[i] - rhs[i]
    }

    return resultVector
  }

  @inlinable public static func + (lhs: Self, rhs: Self) -> Self {
    let rows = Swift.max(lhs.rows, rhs.rows)
    var resultVector = Self(rows: rows)

    for i in 0..<Swift.min(lhs.rows, rhs.rows) {
      resultVector[i] = lhs[i] + rhs[i]
    }

    return resultVector
  }

  @inlinable public static func * (lhs: Self, rhs: Element) -> Self {
    var result = Self(rows: lhs.rows)

    for i in 0..<lhs.rows {
      result[i] = lhs[i] * rhs
    }

    return result
  }

  @inlinable public static func * (lhs: Element, rhs: Self) -> Self {
    rhs * lhs
  }

  @inlinable public static func += (lhs: inout Self, rhs: Self) {
    for i in 0..<Swift.min(lhs.rows, rhs.rows) {
      lhs[i] += rhs[i]
    }
  }

  @inlinable public static func -= (lhs: inout Self, rhs: Self) {
    for i in 0..<Swift.min(lhs.rows, rhs.rows) {
      lhs[i] -= rhs[i]
    }
  }

  @inlinable public static func *= (lhs: inout Self, rhs: Element) {
    for i in 0..<lhs.count {
      lhs[i] *= rhs
    }
  }
}

extension VectorProtocol where Element: Comparable {
  @inlinable public static func < (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 < rhs }
  }

  @inlinable public static func <= (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 <= rhs }
  }

  @inlinable public static func > (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 > rhs}
  }

  @inlinable public static func >= (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 >= rhs }
  }
}

extension VectorProtocol where Element: FloatingPoint {
  @inlinable public static func / (lhs: Self, rhs: Element) -> Self {
    var result = Self(rows: lhs.rows)

    for i in 0..<lhs.count {
      result[i] = lhs[i] / rhs
    }

    return result
  }

  @inlinable public static func / (lhs: Self, rhs: Self) -> Self {
    var result = lhs.clone()

    for i in 0..<result.count {
      result[i] /= rhs[i]
    }

    return result
  }
}

/// - Returns: The component-wise min of two given vectors.
@inlinable public func min<V: VectorProtocol>(_ vec1: V, _ vec2: V) -> V
where V.Element: Comparable {
  V.init((0..<vec1.count).map { vec1[$0] < vec2[$0] ? vec1[$0] : vec2[$0] })
}

/// - Returns: The component-wise max of two given vectors.
@inlinable public func max<V: VectorProtocol>(_ vec1: V, _ vec2: V) -> V
where V.Element: Comparable {
  V.init((0..<vec1.count).map { vec1[$0] > vec2[$0] ? vec1[$0] : vec2[$0] })
}