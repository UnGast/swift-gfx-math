public protocol Line: CustomDebugStringConvertible {
    associatedtype VectorProtocol: GfxMath.VectorProtocol where VectorProtocol.Element: BinaryFloatingPoint

    @available(*, deprecated, message: "use origin")
    var point: VectorProtocol { get set }
    var origin: VectorProtocol { get set }
    var direction: VectorProtocol { get set }
    
    init()
    init(point: VectorProtocol, direction: VectorProtocol)
    init(origin: VectorProtocol, direction: VectorProtocol)
}

public extension Line {
    @available(*, deprecated, message: "use init(origin:, direction:)")
    init(point: VectorProtocol, direction: VectorProtocol) {
        self.init(origin: point, direction: direction)
    }

    init(origin: VectorProtocol, direction: VectorProtocol) {
        self.init()
        self.point = point
        self.direction = direction.normalized()
    }

    init(from point1: VectorProtocol, to point2: VectorProtocol) {
        self.init()
        self.point = point1
        self.direction = (point1 - point2).normalized()
    }

    var debugDescription: String {
        "Line x = (\(point)) + scale * (\(direction))"
    }

    var point: VectorProtocol {
        get { origin }
        set { origin = newValue }
    }

    /// assuming: resultVec = pointOnLineVec + scale * directionVec 
    @available(*, deprecated, message: "use pointAt(scale:)")
    func pointAtScale(_ scale: VectorProtocol.Element) -> VectorProtocol {
        pointAt(scale: scale)
    }

    func pointAt(scale: VectorProtocol.Element) -> VectorProtocol {
        return point + direction * scale
    }

    func scaleAt(_ point: VectorProtocol, accuracy: VectorProtocol.Element = VectorProtocol.Element(vectorComparisonAccuracy)) -> VectorProtocol.Element? {
        var lastScale: VectorProtocol.Element?
        for axis in 0..<direction.count {
            if direction[axis] == 0 {
                // TODO: maybe need accuracy here too
                if abs(self.point[axis] - point[axis]) > accuracy {
                    return nil
                }
            } else {
                let scale = (point[axis] - self.point[axis]) / direction[axis]
                if lastScale == nil {
                    lastScale = scale
                } else if abs(scale - lastScale!) > accuracy {
                    return nil
                }
            }
        }
        return lastScale 
    }

    func contains(_ point: VectorProtocol, accuracy: VectorProtocol.Element = VectorProtocol.Element(vectorComparisonAccuracy)) -> Bool {
        return scaleAt(point, accuracy: accuracy) != nil ? true : false
    }

    func pointBetween(test testPoint: VectorProtocol, from markPoint1: VectorProtocol, to markPoint2: VectorProtocol, accuracy: VectorProtocol.Element = VectorProtocol.Element(vectorComparisonAccuracy)) -> Bool {
        guard let testPointScale = scaleAt(testPoint),
        let markPoint1Scale = scaleAt(markPoint1),
        let markPoint2Scale = scaleAt(markPoint2) else {
            return false
        }

        return
            (testPointScale <= markPoint1Scale + accuracy && testPointScale >= markPoint2Scale - accuracy) ||
            (testPointScale >= markPoint1Scale - accuracy && testPointScale <= markPoint2Scale + accuracy)
    }
}

public extension Line where VectorProtocol: Vector2Protocol {
    // TODO: what to return on identical
    /// - Returns: nil if parallel, self.point when identical, intersection point if intersecting
    func intersect<O: Line>(line otherLine: O) -> VectorProtocol? where O.VectorProtocol == VectorProtocol {
        // self --> line1
        // otherLine --> line2
        let slope1 = self.direction.x / self.direction.y
        let slope2 = otherLine.direction.x / otherLine.direction.y
        
        // TODO: which value to use as accuracy?
        if slope1 == slope2 || abs(slope1 - slope2) < VectorProtocol.Element(0.1) {
            if contains(otherLine.point) {
                return point
            } else {
                return nil
            }
        }
        
        let scale1 = (otherLine.point - self.point).cross(otherLine.direction) / self.direction.cross(otherLine.direction)

        return pointAtScale(scale1)
    }
}

public extension Line where VectorProtocol: Vector3Protocol {
    func intersect<P: Plane>(plane: P) -> VectorProtocol? where P.VectorProtocol == VectorProtocol {
        if plane.normal.dot(direction) == 0 {
            return nil
        }

        let s = (plane.elevation - plane.normal.dot(point)) / (plane.normal.dot(direction))
        return pointAtScale(s)
    }
}

public struct AnyLine<V: VectorProtocol>: Line where V.Element: BinaryFloatingPoint {
    public typealias VectorProtocol = V
    public var origin: V
    public var direction: V
    
    public init() {
        self.origin = V.zero
        self.direction = V.zero
    }
}