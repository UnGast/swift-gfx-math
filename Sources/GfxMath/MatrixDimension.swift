public protocol MatrixDimension {
  var rows: Int { get }
  var cols: Int { get }
}

extension MatrixDimension {
  public var itemCount: Int {
    rows * cols
  }
}

public protocol StaticMatrixDimension: MatrixDimension {
  static var rows: Int { get }
  static var cols: Int { get }
}

extension StaticMatrixDimension {
  public static var itemCount: Int { 
    rows * cols
  }

  public var rows: Int {
    Self.rows
  }

  public var cols: Int {
    Self.cols
  }
}

public struct Dim_2x1: StaticMatrixDimension {
  public static let rows = 2
  public static let cols = 2
}
public struct Dim_3x1: StaticMatrixDimension {
  public static let rows = 3
  public static let cols = 1
}
public struct Dim_3x3: StaticMatrixDimension {
  public static let rows = 3
  public static let cols = 3
}
public struct Dim_4x1: StaticMatrixDimension {
  public static let rows = 4
  public static let cols = 1
}
public struct Dim_nx1: MatrixDimension {
  public let rows: Int
  public let cols: Int = 1

  public init(rows: Int) {
    self.rows = rows
  }
}