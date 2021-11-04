#if canImport(Swim)
import Swim 

extension ERGBColor {
  public var swim: Swim.Color<RGB, DataType> {
    Swim.Color(r: r, g: g, b: b)
  }
}
#endif