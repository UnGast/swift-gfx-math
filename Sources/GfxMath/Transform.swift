public enum DTransform2 {
  case translate(DVec2)
  case scale(DVec2, origin: DVec2? = nil)

  public func transform(point: DVec2) -> DVec2 {
    switch self {
    case let .translate(translation):
      return point + translation
    case let .scale(scale, origin):
      var result = point
      if let origin = origin {
        result -= origin
      }
      result *= scale
      if let origin = origin {
        result += origin
      }
      return result
    }
  }

  public func transform(size: DSize2) -> DSize2 {
    switch self {
    case .translate(_):
      return size
    case let .scale(scale, _):
      return size * scale.abs()
    }
  }
}

extension Array where Element == DTransform2 {
  /** applies the transforms in the order in which they were added */
  public func transform(point: DVec2) -> DVec2 {
    var result = point
    for transform in self {
      result = transform.transform(point: result)
    }
    return result
  }

  /** applies the transforms in reverse order */
  public func transform(size: DSize2) -> DSize2 {
    var result = size
    for transform in self.reversed() {
      result = transform.transform(size: result)
    }
    return result
  }

  /** applies the transforms in reverse order */
  public func transform(rect: DRect) -> DRect {
    DRect(min: transform(point: rect.min), max: transform(point: rect.max))
  }
}