import Foundation

extension VectorProtocol {
  @inlinable public func dot(_ otherVector: Self) -> Element {
    var result = Element.zero
    for i in 0..<count {
      result += self[i] * otherVector[i]
    }
    return result
  }

  @inlinable public static func += <O: VectorProtocol>(lhs: inout Self, rhs: O) where O.Dimension == Dimension, O.Element == Element {
    for i in 0..<lhs.rows {
      lhs[i] += rhs[i]
    }
  }

  @inlinable public static func + <O: VectorProtocol>(lhs: Self, rhs: O) -> Self where O.Dimension == Dimension, O.Element == Element {
    var result = lhs
    result += rhs
    return result
  }

  @inlinable public static func -= <O: VectorProtocol>(lhs: inout Self, rhs: O) where O.Dimension == Dimension, O.Element == Element {
    for i in 0..<lhs.rows {
      lhs[i] -= rhs[i]
    }
  }

  @inlinable public static func - <O: VectorProtocol>(lhs: Self, rhs: O) -> Self where O.Dimension == Dimension, O.Element == Element {
    var result = lhs
    result -= rhs
    return result
  }

  @inlinable public static func *= (lhs: inout Self, rhs: Element) {
    for i in 0..<lhs.count {
      lhs[i] *= rhs
    }
  }

  @inlinable public static func *= (lhs: inout Self, rhs: Self) {
    for i in 0..<lhs.rows {
      lhs[i] *= rhs[i]
    }
  }

  @inlinable public static func * (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result *= rhs
    return result
  }
}

extension VectorProtocol where Dimension: StaticMatrixDimension, Element: Comparable, Element: BinaryFloatingPoint, Element.RawSignificand: FixedWidthInteger {
  @inlinable public static func random(in range: Range<Element>) -> Self {
    let elements = Array(0..<Dimension.itemCount).map { _ in Element.random(in: range) }
    return Self(elements)
  }

  @inlinable public static func random(in range: ClosedRange<Element>) -> Self where Element.Stride: SignedInteger {
    return Self.random(in: Range(range))
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

  @inlinable public static func < <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] < rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func <= <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] <= rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func > <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] > rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func >= <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] >= rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public func componentMagnitudesBelow(threshold: Element) -> Bool {
    elements.allSatisfy { $0 < threshold }
  }

  @inlinable public func componentMagnitudesBelow(threshold: Element) -> Bool where Element: SignedNumeric {
    elements.allSatisfy { Swift.abs($0) < threshold }
  }
}

extension VectorProtocol where Element: FloatingPoint {
  @inlinable public static func /= (lhs: inout Self, rhs: Element) {
   for i in 0..<lhs.count {
      lhs[i] = lhs[i] / rhs
    }
  }

  @inlinable public static func / (lhs: Self, rhs: Element) -> Self {
    var result = lhs
    result /= rhs
    return result
  }

  @inlinable public static func /= (lhs: inout Self, rhs: Self) {
    for i in 0..<lhs.count {
      lhs[i] /= rhs[i]
    }
  }

  @inlinable public static func / (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result /= rhs
    return result
  }

  @inlinable public var lengthSquared: Element {
    var sum: Element = 0
    for element in self {
      sum += element * element
    }
    return sum
  }

  @inlinable public var length: Element {
    sqrt(lengthSquared)
  }

  /// same as length
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

extension Vector3Protocol where Element: FloatingPointGenericMath {
  /// - Returns 0 to pi (positive only)
  @inlinable public func absAngle(to otherVector: Self) -> Element {
    let angle = acos(normalized().dot(otherVector.normalized()))
    return angle
  }

  /**
  internally constructs a quaternion to perform the rotation
  - Parameter angle: angle by which to rotate in degrees
  - Parameter axis: axis around which to rotate, will be normalized automatically
  */
  @inlinable public func rotated<V: Vector3Protocol>(by angle: Element, around axis: V) -> Self where V.Element == Element {
    let rotationQuat = Quaternion(angle: angle, axis: axis)
    return rotated(by: rotationQuat)
  }
  
  @inlinable public func rotated(by quaternion: Quaternion<Element>) -> Self {
    let rotatedQuat = quaternion * Quaternion(w: 0, axis: self) * quaternion.inverse
    return Self(rotatedQuat.axis.elements)
  }

  /**
  - Returns: any vector perpendicular to this one; .zero if this vector is .zero

  UNTESTED!
  */
  @inlinable public func getAnyPerpendicular() -> Self {
    if x != 0 {
      return Self([(-y - z) / x, 1, 1])
    } else if y != 0 {
      return Self([1, (-x - z) / y, 1])
    } else if z != 0 {
      return Self([1, 1, (-x - y) / z])
    } else {
      return .zero
    }
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