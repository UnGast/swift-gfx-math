public struct Triangle<V: VectorProtocol> {
  public typealias Vector = V

  public var vertexA: V
  public var vertexB: V
  public var vertexC: V
  public var vertices: [V] {
    [vertexA, vertexB, vertexC]
  }

  public init(_ a: V, _ b: V, _ c: V) {
    self.vertexA = a
    self.vertexB = b
    self.vertexC = c
  }

  private static func pointsOnSameSideOfLine<E: BinaryFloatingPoint>(p1: Vector3<E>, p2: Vector3<E>, a: Vector3<E>, b: Vector3<E>) -> Bool {
    let cross1 = (a - p1).cross(a - b)
    let cross2 = (a - p2).cross(a - b)
    let dot = cross1.dot(cross2)
    return dot > 0
  }

  public func contains(point: V) -> Bool where V: Vector2Protocol, V.Element: BinaryFloatingPoint {
    let point3d = Vector3<V.Element>(point.x, point.y, 0)
    let vertices3d = vertices.map { Vector3<V.Element>($0.x, $0.y, 0) }
    return Self.pointsOnSameSideOfLine(p1: point3d, p2: vertices3d[2], a: vertices3d[0], b: vertices3d[1])
      && Self.pointsOnSameSideOfLine(p1: point3d, p2: vertices3d[0], a: vertices3d[1], b: vertices3d[2])
      && Self.pointsOnSameSideOfLine(p1: point3d, p2: vertices3d[1], a: vertices3d[0], b: vertices3d[2])
  }

  public func getBarycentricCoordinates(of point: V) -> DVec3 {
    fatalError("not implemented")
  }
}

extension Triangle where V: Vector2Protocol, V.Element: BinaryFloatingPoint {
  public var area: V.Element {
    let v1 = vertexB - vertexA
    let v2 = vertexC - vertexA
    return abs(v1.cross(v2)) / 2
  }

}