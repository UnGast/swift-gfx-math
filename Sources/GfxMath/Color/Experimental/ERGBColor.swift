public protocol ERGBColor: EColor {
  associatedtype DataType

  var r: DataType { get }
  var g: DataType { get }
  var b: DataType { get }
}