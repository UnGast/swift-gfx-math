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

  static var allTests = [
    ("testVectorScalarComparison", testVectorScalarComparison),
    ("testVectorVectorComparison", testVectorVectorComparison)
  ]
}