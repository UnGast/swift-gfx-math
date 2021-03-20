//

//

import Foundation

public typealias Size<E: Numeric & Hashable> = Vector<E>

public typealias Size3<E: Numeric & Hashable> = Vector3<E>

public protocol Size2Protocol: Vector2Protocol {

}

public extension Size2Protocol {

    var width: Element {

        get {

            return x
        }

        set {

            x = newValue
        }
    }

    var height: Element {

        get {

            return y
        }

        set {

            y = newValue
        }
    }
}

public typealias Size2<E: Numeric & Hashable> = Vector2<E>

extension Size2 {
    public var width: E {
        get { x }
        set { x = newValue }
    }
    public var height: E {
        get { y }
        set { y = newValue }
    }
}

public typealias DSize2 = Size2<Double>
public typealias ISize2 = Size2<Int>
public typealias DSize3 = Size3<Double>
public typealias ISize3 = Size3<Int>