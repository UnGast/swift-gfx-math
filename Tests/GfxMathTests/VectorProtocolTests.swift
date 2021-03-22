import XCTest
import GfxMath

class VectorProtocolTests: XCTestCase {
  func testVectorScalarComparison() {
    var vector = DVec2(2, 5)
    XCTAssertTrue(vector < 6)
    XCTAssertFalse(vector < 5)
    XCTAssertFalse(vector < 2)
    XCTAssertTrue(vector <= 5)
    XCTAssertFalse(vector <= 2)

    XCTAssertTrue(vector > 1)
    XCTAssertFalse(vector > 2)
    XCTAssertFalse(vector > 5)
    XCTAssertTrue(vector >= 2)
    XCTAssertFalse(vector >= 5)

    vector = DVec2(3, 3)
    XCTAssertTrue(vector <= 4)
    XCTAssertTrue(vector < 4)
    XCTAssertFalse(vector < 2)
    XCTAssertTrue(vector <= 3)
    XCTAssertTrue(vector >= 3)
    XCTAssertFalse(vector > 4)
  }

  func testVectorVectorComparison() {
    var vector1 = DVec2(1, 2)
    var vector2 = DVec2(3, 4)
    XCTAssertTrue(vector1 < vector2)
    XCTAssertTrue(vector1 <= vector2)
    XCTAssertFalse(vector1 > vector2)
    XCTAssertFalse(vector1 >= vector2)
    XCTAssertTrue(vector2 > vector1)
    XCTAssertTrue(vector2 >= vector1)
    XCTAssertFalse(vector2 < vector1)
    XCTAssertFalse(vector2 <= vector1)

    vector1 = DVec2(1, 1)
    vector2 = DVec2(1, 2)
    XCTAssertTrue(vector1 <= vector2)
    XCTAssertFalse(vector1 < vector2)
    XCTAssertFalse(vector1 >= vector2)
    XCTAssertTrue(vector2 >= vector1)
    XCTAssertFalse(vector2 > vector1)
    XCTAssertFalse(vector2 <= vector1)

    vector1 = DVec2(1, 1)
    vector2 = DVec2(1, 1)
    XCTAssertFalse(vector1 < vector2)
    XCTAssertFalse(vector1 > vector2)
    XCTAssertTrue(vector1 <= vector2)
    XCTAssertTrue(vector1 >= vector2)
  }

  func testVectorAddition() {
    let vector1 = DVec2(40, 10)
    let vector2 = DVec2(-10, -15)
    var vector3 = DVec2.zero
    vector3 += vector1
    vector3 += vector2
    XCTAssertEqual(vector1 + vector2, DVec2(30, -5))
    XCTAssertEqual(vector3, DVec2(30, -5))
  }

  func testVectorSubtraction() {
    let vector1 = DVec2(50, 40)
    let vector2 = DVec2(10, -30)
    var vector3 = DVec2.zero
    vector3 -= vector1
    vector3 -= vector2
    XCTAssertEqual(vector1 - vector2, DVec2(40, 70))
    XCTAssertEqual(vector3, DVec2(-60, -10))
  }

  func testVectorMultiplication() {
    let vector1 = DVec2(10, 20)
    let vector2 = DVec2(0, 0)
    let vector3 = DVec2(5, 6)
    var vector4 = DVec2(1, 1)

    vector4 *= vector1
    XCTAssertEqual(vector4, DVec2(10, 20))

    vector4 *= 5
    XCTAssertEqual(vector4, DVec2(50, 100))

    vector4 *= vector2
    XCTAssertEqual(vector4, .zero)  

    XCTAssertEqual(vector1 * vector2, .zero)
    XCTAssertEqual(vector1 * vector3, DVec2(50, 120))
    XCTAssertEqual(vector1 * vector3 * 2, DVec2(100, 240))
  }

  func testVectorDivision() {
    let vector1 = DVec2(40, 70)
    let vector2 = DVec2(4, 2)
    let vector3 = DVec2(1, 1)
    let vector4 = DVec2.zero
    var vector5 = DVec2(80, 90)

    vector5 /= vector2
    XCTAssertEqual(vector5, DVec2(20, 45))

    vector5 /= vector3
    XCTAssertEqual(vector5, DVec2(20, 45))

    vector5 /= 2
    XCTAssertEqual(vector5, DVec2(10, 22.5))

    vector5 /= vector4
    XCTAssertEqual(vector5, DVec2.infinity)

    XCTAssertEqual(vector1 / vector2, DVec2(10, 35))
    XCTAssertEqual(vector1 / 2, DVec2(20, 35))
    XCTAssertEqual(vector1 / vector3, vector1)
    XCTAssertEqual(vector1 / vector4, .infinity)
  }

  func testVector3Rotation() {
    let angle = 180.0
    let axis = Vector3(1.0, 0, 0)
    let vector = Vector3(0.0, 0.0, -1.0)
    let result = vector.rotated(by: angle, around: axis)
    XCTAssertEqual(result.x, 0)
    XCTAssertEqual(result.y, 0.0, accuracy: 0.001)
    XCTAssertEqual(result.z, 1.0, accuracy: 0.001)
  }

  static var allTests = [
    ("testVectorScalarComparison", testVectorScalarComparison),
    ("testVectorVectorComparison", testVectorVectorComparison),
    ("testVectorAddition", testVectorAddition),
    ("testVectorSubtraction", testVectorSubtraction),
    ("testVectorMultiplication", testVectorMultiplication),
    ("testVectorDivision", testVectorDivision),
    ("testVector3Rotation", testVector3Rotation)
  ]
}