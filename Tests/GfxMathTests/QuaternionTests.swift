import XCTest
@testable import GfxMath

class QuaternionTests: XCTestCase {
  func testAngleUnnormalizedAxisInit() {
    let angle = 180.0
    let axis = Vector3(2.0, 3.0, -2.0)
    let quat = Quaternion(angle: angle, axis: axis)
    XCTAssertEqual(quat.w, cos((angle / 2) / 180 * Double.pi))
    XCTAssertEqual(quat.axis, sin((angle / 2) / 180 * Double.pi) * axis.normalized())
  }

  func testMultiplication() {
    let quat1 = Quaternion(2.0, 3.0, 4.0, 3.0)
    let quat2 = Quaternion(-1.0, 3.9, 4.0, -3.0)
    let result = quat1 * quat2
    XCTAssertEqual(result.w, -20.7)
    XCTAssertEqual(result.x, -19.2)
    XCTAssertEqual(result.y, 24.70)
    XCTAssertEqual(result.z, -12.6)
  }

  func testMatrix3Conversion() {
    let mat3 = Quaternion(angle: 90, axis: FVec3(0, 1, 0)).mat3
    XCTAssertEqual(mat3[0,0], 0, accuracy: 0.1)
    XCTAssertEqual(mat3[0,1], 0, accuracy: 0.1)
    XCTAssertEqual(mat3[0,2], 1, accuracy: 0.1)
    XCTAssertEqual(mat3[1,0], 0, accuracy: 0.1)
    XCTAssertEqual(mat3[1,1], 1, accuracy: 0.1)
    XCTAssertEqual(mat3[1,2], 0, accuracy: 0.1)
    XCTAssertEqual(mat3[2,0], -1, accuracy: 0.1)
    XCTAssertEqual(mat3[2,1], 0, accuracy: 0.1)
    XCTAssertEqual(mat3[2,2], 0, accuracy: 0.1)
  }

  static var allTests = [
    ("testAngleUnnormalizedAxisInit", testAngleUnnormalizedAxisInit),
    ("testMultiplication", testMultiplication),
    ("testMatrix3Conversion", testMatrix3Conversion)
  ]
}