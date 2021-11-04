public protocol ERGBAColor: EColor {
  associatedtype DataType

  var r: DataType { get }
  var g: DataType { get }
  var b: DataType { get }
  var a: DataType { get }
}