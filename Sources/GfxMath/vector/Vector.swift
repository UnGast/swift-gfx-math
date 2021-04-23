import Foundation

public struct Vector<E: Numeric & Hashable>: VectorProtocol {
  public typealias Element = E
  public typealias Dimension = Dim_nx1

  public let rows: Int
  public let cols: Int = 1
  public var elements: [Element]

  public init(_ elements: [Element]) {
    self.rows = elements.count
    self.elements = elements
  }

  /// a vector without elements, since the size is not known
  @inlinable public static var zero: Self {
    Self([])
  }
}

public protocol Vector2Protocol: VectorProtocol {
  var x: Element { get set }
  var y: Element { get set }
}

extension Vector2Protocol {
  public typealias Dimension = Dim_2x1

  @inlinable public static var zero: Self {
    Self([0, 0])
  }

  @inlinable public var x: Element {
    get {
      return elements[0]
    }

    set {
      elements[0] = newValue
    }
  }

  @inlinable public var y: Element {
    get {
      return elements[1]
    }

    set {
      elements[1] = newValue
    }
  }

  @inlinable public var tuple: (x: Element, y: Element) {
    (x, y)
  }

  @inlinable public func cross(_ other: Self) -> Element {
    return self.x * other.y - self.y * other.x
  }
}

extension Vector2Protocol
where Element: BinaryFloatingPoint, Element.RawSignificand: FixedWidthInteger {
  @inlinable public static var infinity: Self {
    Self([Element.infinity, Element.infinity])
  }

  @inlinable public static func random(in bounds: Rect<Element>) -> Self {
    self.init([
      Element.random(in: bounds.min.x...bounds.max.x),
      Element.random(in: bounds.min.y...bounds.max.y)
    ])
  }
}

public struct Vector2<E: Numeric & Hashable>: Vector2Protocol {
  public typealias Element = E
  public let rows: Int = 2
  public let cols: Int = 1
  public var elements: [Element]

  public init(_ elements: [Element]) {
    self.elements = elements
  }

  public init(_ x: Element, _ y: Element) {
    self.init([x, y])
  }

  public init(x: Element, y: Element) {
    self.init([x, y])
  }
}

public protocol Vector3Protocol: VectorProtocol {

}

extension Vector3Protocol {
  public typealias Dimension = Dim_3x1

  @inlinable public static var zero: Self {
    Self([0, 0, 0])
  }

  @inlinable public func cross(_ rhs: Self) -> Self {
    let x = self[1] * rhs[2] - self[2] * rhs[1]
    let y = self[2] * rhs[0] - self[0] * rhs[2]
    let z = self[0] * rhs[1] - self[1] * rhs[0]

    return Self([
      x,
      y,
      z,
    ])
  }

  @inlinable public var x: Element {
    get {
      return elements[0]
    }

    set {
      elements[0] = newValue
    }
  }

  @inlinable public var y: Element {
    get {
      return elements[1]
    }

    set {
      elements[1] = newValue
    }
  }

  @inlinable public var z: Element {
    get {
      return elements[2]
    }

    set {
      elements[2] = newValue
    }
  }
}

public struct Vector3<E: Numeric & Hashable>: Vector3Protocol {
  public typealias Element = E
  public let rows: Int = 3
  public let cols: Int = 1
  public var elements: [Element]

  public init(_ elements: [Element]) {
    self.elements = elements
  }

  public init(_ x: Element, _ y: Element, _ z: Element) {
    self.elements = [x, y, z]
  }

  public init(x: Element, y: Element, z: Element) {
    self.elements = [x, y, z]
  }
}

public protocol Vector4Protocol: VectorProtocol {

}

extension Vector4Protocol {
  public typealias Dimension = Dim_4x1

  @inlinable public static var zero: Self {
    Self([0, 0, 0, 0])
  }

  @inlinable public var x: Element {
    get {
      return elements[0]
    }

    set {
      elements[0] = newValue
    }
  }

  @inlinable public var y: Element {
    get {
      return elements[1]
    }

    set {
      elements[1] = newValue
    }
  }

  @inlinable public var z: Element {
    get {
      return elements[2]
    }

    set {
      elements[2] = newValue
    }
  }

  @inlinable public var w: Element {
    get {
      return elements[3]
    }

    set {
      elements[3] = newValue
    }
  }
}

public struct Vector4<E: Numeric & Hashable>: Vector4Protocol {
  public typealias Element = E
  public let rows: Int = 4
  public let cols: Int = 1
  public var elements: [Element]

  public init(_ elements: [Element]) {
    self.elements = elements
  }

  public init(_ vec3: Vector3<E>, _ element: Element) {
    self.elements = vec3.elements + [element]
  }

  public init(_ x: Element, _ y: Element, _ z: Element, _ w: Element) {
    self.init([x, y, z, w])
  }
}

extension Matrix4Protocol {
  @inlinable public static func matmul<VectorProtocol: Vector4Protocol>(_ other: VectorProtocol)
    -> VectorProtocol where Self.Element == VectorProtocol.Element
  {
    return VectorProtocol(try! self.matmul(other).elements)
  }
}

public typealias DVec2 = Vector2<Double>
public typealias FVec2 = Vector2<Float>
public typealias IVec2 = Vector2<Int>
public typealias DVec3 = Vector3<Double>
public typealias IVec3 = Vector3<Int>
public typealias FVec3 = Vector3<Float>
public typealias DVec4 = Vector4<Double>
public typealias FVec4 = Vector4<Float>
