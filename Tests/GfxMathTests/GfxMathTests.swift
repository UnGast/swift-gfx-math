import XCTest
@testable import GfxMath

final class GfxMathTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GfxMath().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
