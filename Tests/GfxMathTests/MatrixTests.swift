import XCTest
@testable import GfxMath

class MatrixTests: XCTestCase {
  func testMat4InitTopLeftMat3() {
    let mat3 = Matrix3([
      1, 2, 3,
      5, 6, 7,
      9, 10, 11
    ])
    let mat4 = Matrix4(topLeft: mat3, rest: Matrix4([
      0, 0, 0, 4,
      0, 0, 0, 8,
      0, 0, 0, 12,
      13, 14, 15, 16
    ]))
    XCTAssertEqual(mat4, Matrix4([
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10, 11, 12,
      13, 14, 15, 16
    ]))
  }

  static var allTests = [
    ("testMat4InitTopLeftMat3", testMat4InitTopLeftMat3)
  ]
}