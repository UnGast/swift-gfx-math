public enum DTransform2 {
  case translate(DVec2)

  public func transform(point: DVec2) -> DVec2 {
    switch self {
    case let .translate(translation):
      return point + translation
    }
  }
}

extension Array where Element == DTransform2 {
  public func transform(point: DVec2) -> DVec2 {
    var result = point
    for transform in self {
      result = transform.transform(point: result)
    }
    return result
  }

  public func transform(rect: DRect) -> DRect {
    DRect(min: transform(point: rect.min), max: transform(point: rect.max))
  }
}