import Foundation

/// Axis aligned rect in 2 coordinate space.
public struct Rect<D: Numeric & Hashable & Comparable>: Equatable, Hashable {
    public typealias Data = D

    public var min: Vector2<Data>
    public var max: Vector2<Data> {
        min + Vector2<Data>(size)
    }

    public var size: Size2<Data>

    
    public var width: Data {
        get {
            size.width
        }
        set {
            size.width = newValue
        }
    }

    public var height: Data {
        get {
            size.height
        }
        set {
            size.height = newValue
        }
    }

    public var area: Data {
        size.width * size.height
    }

    // TODO: maybe implement as protocol as well and don't use Vector2<Data> but Vector2Protocol where Vector2Protocol.E == E?
    public init(min: Vector2<Data>, size: Size2<Data>) {
        self.min = min
        self.size = size
    }

    public init(max: Vector2<Data>, size: Size2<Data>) {
        self.min = max - Vector2<Data>(size)
        self.size = size
    }

    public init(min: Vector2<Data>, max: Vector2<Data>/*, layout: VectorLayout2<Vector2<Data>> = .bottomLeftToTopRight*/) {
        self.min = min
        self.size = Size2(max - min)
    }

    /// create a rect containing all given points
    public init(containing points: [Vector2<Data>]) {
        var minX: Data? = nil
        var minY: Data? = nil
        var maxX: Data? = nil
        var maxY: Data? = nil

        for point in points {
            if minX == nil || point.x < minX! {
                minX = point.x
            }
            if minY == nil || point.y < minY! {
                minY = point.y
            }
            if maxX == nil || point.x > maxX! {
                maxX = point.x
            }
            if maxY == nil || point.y > maxY! {
                maxY = point.y
            }
        }

        self.init(min: Vector2(minX ?? 0, minY ?? 0), max: Vector2(maxX ?? 0, maxY ?? 0))
    }

    public var vertices: [Vector2<Data>] {
        [
            min,
            min + Vector2(size.x, 0),
            min + Vector2(0, size.y),
            max
        ]
    }

    public func contains(point: Vector2<Data>) -> Bool {
        return point.x >= min.x && point.x <= max.x && point.y >= min.y && point.y <= max.y
    }

    public func intersects(_ otherRect: Rect<Data>) -> Bool {
        return !(min.x > otherRect.max.x || max.x < otherRect.min.x || min.y > otherRect.max.y || max.y < otherRect.min.y)
    }

    public func intersection(with otherRect: Rect<Data>) -> Rect<Data>? {
        if intersects(otherRect) {
            return Rect(
                min: Vector2(Swift.max(min.x, otherRect.min.x), Swift.max(min.y, otherRect.min.y)),
                max: Vector2(Swift.min(max.x, otherRect.max.x), Swift.min(max.y, otherRect.max.y))
            )
        }
        return nil
    }

    public mutating func translate(_ amount: Vector2<Data>) {
        self.min += amount
    }

    public func translated(_ amount: Vector2<Data>) -> Self {
        var result = self
        result.translate(amount)
        return result
    }
}

extension Rect where Data: FloatingPoint {
    public var center: Vector2<Data> {
        min + Vector2<Data>(size) / 2
    }

    public init(center: Vector2<Data>, size: Size2<Data>) {
        self.init(min: Vector2<Data>(center.x - size.width / 2, center.y - size.height / 2), size: size)
    }
    
    /// UNTESTED!
    public func intersections<L: LineProtocol>(with line: L) -> (min: Vector2<Data>, max: Vector2<Data>)? where L.VectorProtocol: Vector2Protocol, L.VectorProtocol.Element == D {
        // this can be generalized for any axis aligned bounding box (also 3d, 4d probably, etc.)
        var minScale = -Data.infinity
        var maxScale = Data.infinity
        for dimension in 0..<2 {
            var newMinScale = (min[dimension] - line.origin[dimension]) / line.direction[dimension]
            var newMaxScale = (max[dimension] - line.origin[dimension]) / line.direction[dimension]
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

        return (min: Vector2<Data>(line.pointAt(scale: minScale)), max: Vector2<Data>(line.pointAt(scale: maxScale)))
    }
}

extension Rect where Data: BinaryFloatingPoint {
    public init<O: BinaryFloatingPoint>(_ other: Rect<O>) {
        self.init(min: Vector2<Data>(other.min), max: Vector2<Data>(other.max))
    }
}

/// An axis aligned Rect in 2 coordinate space.
/// - SeeAlso: Rect
public typealias DRect = Rect<Double>
public typealias FRect = Rect<Float>
public typealias IRect = Rect<Int>