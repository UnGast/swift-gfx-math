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

    public func contains(point: Vector2<E>) -> Bool {
        return point.x >= min.x && point.x <= max.x && point.y >= min.y && point.y <= max.y
    }

    public func intersects(_ otherRect: Rect<E>) -> Bool {
        return !(min.x > otherRect.max.x || max.x < otherRect.min.x || min.y > otherRect.max.y || max.y < otherRect.min.y)
    }

    public func intersection(with otherRect: Rect<E>) -> Rect<E>? {
        if intersects(otherRect) {
            return Rect(
                min: Vector2(Swift.max(min.x, otherRect.min.x), Swift.max(min.y, otherRect.min.y)),
                max: Vector2(Swift.min(max.x, otherRect.max.x), Swift.min(max.y, otherRect.max.y))
            )
        }
        return nil
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
    
    /// UNTESTED!
    public func intersections<L: LineProtocol>(with line: L) -> (min: Vector2<E>, max: Vector2<E>)? where L.VectorProtocol: Vector2Protocol, L.VectorProtocol.Element == E {
        // this can be generalized for any axis aligned bounding box (also 3d, 4d probably, etc.)
        var minScale = -E.infinity
        var maxScale = E.infinity
        for dimension in 0..<2 {
            var newMinScale = (min[dimension] - line.point[dimension]) / line.direction[dimension]
            var newMaxScale = (max[dimension] - line.point[dimension]) / line.direction[dimension]
            if newMinScale > newMaxScale {
                let tmp = newMinScale
                newMinScale = newMaxScale
                newMaxScale = tmp
            }
            minScale = Swift.max(minScale, newMinScale)
            maxScale = Swift.min(maxScale, newMaxScale)
            
            if maxScale < minScale {
                return nil
            }
        }

        return (min: Vector2<E>(line.pointAtScale(minScale)), max: Vector2<E>(line.pointAtScale(maxScale)))
    }
}

extension Rect where E: BinaryFloatingPoint {
    public init<O: BinaryFloatingPoint>(_ other: Rect<O>) {
        self.init(min: Vector2<E>(other.min), max: Vector2<E>(other.max))
    }
}

/// An axis aligned Rect in 2 coordinate space.
/// - SeeAlso: Rect
public typealias DRect = Rect<Double>
public typealias FRect = Rect<Float>
public typealias IRect = Rect<Int>