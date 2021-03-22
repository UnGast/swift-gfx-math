import XCTest
@testable import GfxMath

class QuaternionTests: XCTestCase {
  func testAngleUnnormalizedAxisInit() {
    let angle = 180.0
    let axis = Vector3(2.0, 3.0, -2.0)
    let quat = Quaternion(angle: angle, axis: axis)
    XCTAssertEqual(quat.w, cos(angle / 180 * Double.pi))
    XCTAssertEqual(quat.axis, sin(angle / 180 * Double.pi) * axis.normalized())
  }

  func testMultiplication() {
    let quat1 = Quaternion(2.0, 3.0, 4.0, 3.0)
    let quat2 = Quaternion(-1.0, 3.9, 4.0, -3.0)
    let result = quat1 * quat2
    XCTAssertEqual(result.w, -20.7)
    XCTAssertEqual(result.x, -19.2)
    XCTAssertEqual(result.y, 24.7)
    XCTAssertEqual(result.z, -12.6)
  }

  static var allTests = [
    ("testAngleUnnormalizedAxisInit", testAngleUnnormalizedAxisInit),
    ("testMultiplication", testMultiplication)
  ]
}