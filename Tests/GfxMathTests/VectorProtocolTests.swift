import XCTest
import GfxMath

class VectorProtocolTests: XCTestCase {
  func testScalarComparison() {
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

  static var allTests = [
    ("testScalarComparison", testScalarComparison)
  ]
}