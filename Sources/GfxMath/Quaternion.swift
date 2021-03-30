public struct Quaternion<E: FloatingPointGenericMath>: Equatable {
  public typealias Element = E

  public var w: E
  public var axis: Vector3<E>

  /**
  - Parameter angle: rotation angle in degrees,
  will be halved automatically for use with q*v*q^-1
  - Parameter axis: axis around which to rotate, will be normalized automatically
  */
  public init<V: Vector3Protocol>(angle: Element, axis: V) where V.Element == Element {
    self.init(w: cos((angle / 2) / 180 * Element.pi), axis: sin((angle / 2) / 180 * Element.pi) * axis.normalized())
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

  public var mat3: Matrix3<Element> {
    /*let rotatedX = Vector3<Element>(1, 0, 0).rotated(by: self)
    let rotatedY = Vector3<Element>(0, 1, 0).rotated(by: self)
    let rotatedZ = Vector3<Element>(0, 0, 1).rotated(by: self)

    return Matrix3<Element>([
      rotatedX.x, rotatedY.x, rotatedZ.x,
      rotatedX.y, rotatedY.y, rotatedZ.y,
      rotatedX.z, rotatedY.z, rotatedZ.z
    ])*/

    let r1c1: Element = 2 * (pow(w, 2) + pow(x, 2)) - 1
    let r1c2: Element = 2 * (x * y - w * z)
    let r1c3: Element = 2 * (x * z + w * y)
    let r2c1: Element = 2 * (x * y + w * z)
    let r2c2: Element = 2 * (pow(w, 2) + pow(y, 2)) - 1
    let r2c3: Element = 2 * (y * z - w * x)
    let r3c1: Element = 2 * (x * z - w * y)
    let r3c2: Element = 2 * (y * z + w * x)
    let r3c3: Element = 2 * (pow(w, 2) + pow(z, 3)) - 1
    return Matrix3<Element>([
      r1c1, r1c2, r1c3,
      r2c1, r2c2, r2c3,
      r3c1, r3c2, r3c3 
    ])
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