//

//

import Foundation

public typealias Size<E: Numeric & Hashable> = Vector<E>

public typealias Size3<E: Numeric & Hashable> = Vector3<E>

public protocol Size2Protocol: Vector2Protocol {

}

extension Size2Protocol {
  public var width: Element {
    get { x }
    set { x = newValue }
  }

  public var height: Element {
    get { y }
    set { y = newValue }
  }
}

public struct Size2<E: Numeric & Hashable>: Size2Protocol {
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

public typealias DSize2 = Size2<Double>
public typealias FSize2 = Size2<Float>
public typealias ISize2 = Size2<Int>
public typealias DSize3 = Size3<Double>
public typealias FSize3 = Size3<Float>
public typealias ISize3 = Size3<Int>
