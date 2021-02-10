import Foundation

/// Axis aligned rect in 2 coordinate space.
public struct Rect<E: Numeric & Hashable & Comparable>: Equatable, Hashable {
    public var min: Vector2<E>
    public var max: Vector2<E> {
        get {
            min + Vector2<E>(size)
        }
        /*set {
            size = Size2<E>(max - min)
        }*/
    }

    public var size: Size2<E>

    
    public var width: E {
        get {
            size.width
        }
        set {
            size.width = newValue
        }
    }

    public var height: E {
        get {
            size.height
        }
        set {
            size.height = newValue
        }
    }

    public var area: E {
        size.width * size.height
    }

    // TODO: maybe implement as protocol as well and don't use Vector2<E> but Vector2Protocol where Vector2Protocol.E == E?
    public init(min: Vector2<E>, size: Size2<E>) {
        self.min = min
        self.size = size
    }

    public init(max: Vector2<E>, size: Size2<E>) {
        self.min = max - Vector2<E>(size)
        self.size = size
    }

    public init(min: Vector2<E>, max: Vector2<E>/*, layout: VectorLayout2<Vector2<E>> = .bottomLeftToTopRight*/) {
        self.min = min
        self.size = Size2(max - min)
    }

    public var vertices: [Vector2<E>] {
        [
            min,
            min + Vector2(size.x, 0),
            min + Vector2(0, size.y),
            max
        ]
    }

    // TODO: might add set operations as well
    /*public var topLeft: Vector2<E> {
        get {
            Vector2<E>()
        }
    }

    // TODO: these calculations need to be redone
    public var bottomLeft: Vector2<E> {
        get {
            return Vector2<E>(topLeft.x, topLeft.y + size.height)
        }
    }

    public var bottomRight: Vector2<E> {
        get {
            return Vector2<E>(topLeft.x + size.width, topLeft.y + size.height)
        }
    }

    public var center: Vector2<E> {
        get {
            return Vector2<E>(topLeft.x + size.width / 2, topLeft.y + size.height / 2)
        }
    }*/

    /**
    - Parameter includeOnEdge: Controls whether a point that is located on an edge or corner counts as inside or not.
    */
    public func contains(point: Vector2<E>, includeOnEdge: Bool = true) -> Bool {
        if includeOnEdge {
            return point.x >= min.x && point.x <= max.x && point.y >= min.y && point.y <= max.y
        } else {
            return point.x > min.x && point.x < max.x && point.y > min.y && point.y < max.y
        }
    }

    /** 
    - Parameter includeSharedEdge: Set whether shared edges (or corners) count as intersection or not.
    */
    public func intersects(_ otherRect: Rect<E>, includeSharedEdge: Bool = true) -> Bool {
        for ownVertex in self.vertices {
            if otherRect.contains(point: ownVertex, includeOnEdge: includeSharedEdge) {
                return true
            }
        }

        for otherVertex in otherRect.vertices {
            if contains(point: otherVertex, includeOnEdge: includeSharedEdge) {
                return true
            }
        } 

        return false
    }

    public func intersection(with otherRect: Rect<E>) -> Rect<E>? {
        var xs = Set([min.x, max.x, otherRect.min.x, otherRect.max.x])
        var ys = Set([min.y, max.y, otherRect.min.y, otherRect.max.y])
        xs = xs.filter { min.x <= $0 && max.x >= $0 && otherRect.min.x <= $0 && otherRect.max.x >= $0 }
        ys = ys.filter { min.y <= $0 && max.y >= $0 && otherRect.min.y <= $0 && otherRect.max.y >= $0 }

        if xs.count < 2 || ys.count < 2 {
            return nil
        }

        let xsSorted = xs.sorted()
        let ysSorted = ys.sorted()
        return Rect<E>(min: Vector2<E>(xsSorted[0], ysSorted[0]), max: Vector2<E>(xsSorted[1], ysSorted[1]))
    }

    public mutating func translate(_ amount: Vector2<E>) {
        self.min += amount
    }

    public func translated(_ amount: Vector2<E>) -> Self {
        var result = self
        result.translate(amount)
        return result
    }
}

extension Rect where E: FloatingPoint {
    public var center: Vector2<E> {
        min + Vector2<E>(size) / 2
    }

    public init(center: Vector2<E>, size: Size2<E>) {
        self.init(min: Vector2<E>(center.x - size.width / 2, center.y - size.height / 2), size: size)
    }
}

/// An axis aligned Rect in 2 coordinate space.
/// - SeeAlso: Rect
public typealias DRect = Rect<Double>
public typealias IRect = Rect<Int>