public struct LineSegment<V: VectorProtocol> where V.Element: BinaryFloatingPoint {
  public typealias Vector = V

  public var scaleMin: Vector.Element
  public var scaleMax: Vector.Element
  public var start: Vector {
    line.pointAtScale(scaleMin)
  }
  public var end: Vector {
    line.pointAtScale(scaleMax)
  }
  public var length: Vector.Element {
    (start - end).length
  }

  public var line: AnyLine<Vector>

  public init(line: AnyLine<Vector>, scaleMin: Vector.Element, scaleMax: Vector.Element) {
    var scaleMin = scaleMin
    var scaleMax = scaleMax

    self.line = line

    if scaleMin > scaleMax {
      let tmp = scaleMin
      scaleMin = scaleMax
      scaleMax = tmp
    }
    self.scaleMin = scaleMin 
    self.scaleMax = scaleMax
  }

  public init(start: Vector, end: Vector) {
    let line = AnyLine(from: start, to: end)
    var scaleMin = line.scaleAt(start)!
    var scaleMax = line.scaleAt(end)!
    self.init(line: line, scaleMin: scaleMin, scaleMax: scaleMax)
  }
}