public struct Quaternion<E: FloatingPointGenericMath>: Equatable {
  public typealias Element = E

  public var w: E
  public var axis: Vector3<E>

  /**
  - Parameter angle: rotation angle in degrees
  - Parameter axis: axis around which to rotate, will be normalized automatically
  */
  public init<V: Vector3Protocol>(angle: Element, axis: V) where V.Element == Element {
    self.init(w: cos(angle / 180 * Element.pi), axis: sin(angle / 180 * Element.pi) * axis.normalized())
  }

  public init<V: Vector3Protocol>(w: E, axis: V) where V.Element == Element {
    self.w = w
    self.axis = Vector3(axis.elements)
  }

  public init<V: Vector3Protocol>(_ w: E, _ axis: V) where V.Element == Element {
    self.init(w: w, axis: axis)
  }

  public init(w: Element, x: Element, y: Element, z: Element) {
    self.init(w: w, axis: Vector3(x, y, z))
  }

  public init(_ w: Element, _ x: Element, _ y: Element, _ z: Element) {
    self.init(w: w, x: x, y: y, z: z)
  }

  public var x: E {
    get { axis.x }
    set { axis.x = newValue }
  }

  public var y: E {
    get { axis.y }
    set { axis.y = newValue }
  }

  public var z: E {
    get { axis.z }
    set { axis.z = newValue }
  }

  public static var identity: Self {
    Self(w: 1, axis: Vector3<Element>.zero)
  }

  public var magnitude: Element {
    (pow(w, 2) + pow(axis.x, 2) + pow(axis.y, 2) + pow(axis.z, 2)).squareRoot()
  }

  public var normalized: Self {
    self / magnitude
  }

  public var conjugate: Self {
    Self(w: w, axis: -axis)
  }

  public var inverse: Self {
    conjugate / magnitude
  }

  /**
  Hamilton product
  */
  public static func * (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    let lAxis = lhs.axis
    let rAxis = rhs.axis
    result.w = lhs.w * rhs.w - lAxis.dot(rAxis)
    result.axis = lhs.w * rAxis + rhs.w * lAxis + lAxis.cross(rAxis)
    return result
  }

  /** 
  divide w, x, y, z by rhs
  */
  public static func /= (lhs: inout Self, rhs: Element) {
    lhs.w /= rhs
    lhs.axis /= rhs
  }

  /** 
  divide w, x, y, z by rhs
  */
  public static func / (lhs: Self, rhs: Element) -> Self {
    var result = lhs
    result /= rhs
    return result
  }
}