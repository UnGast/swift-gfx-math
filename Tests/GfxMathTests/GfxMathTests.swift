import XCTest
@testable import GfxMath

final class GfxMathTests: XCTestCase {
    func testRectangleIntersection() {
        // arbitrary intersection
        var rect1 = DRect(min: DVec2(10, 20), max: DVec2(40, 50))
        var rect2 = DRect(min: DVec2(11, 21), max: DVec2(28, 70))
        var intersection = rect1.intersection(with: rect2)
        XCTAssertNotNil(intersection)
        XCTAssertEqual(intersection!.min, DVec2(11, 21))
        XCTAssertEqual(intersection!.max, DVec2(28, 50))

        // one within the other
        rect1 = DRect(min: DVec2(10, 20), max: DVec2(40, 50))
        rect2 = DRect(min: DVec2(5, 5), max: DVec2(70, 70))
        intersection = rect1.intersection(with: rect2)
        XCTAssertNotNil(intersection)
        XCTAssertEqual(intersection!.min, DVec2(10, 20))
        XCTAssertEqual(intersection!.max, DVec2(40, 50))

        // no intersection with space inbetween
        rect1 = DRect(min: DVec2(1, 1), max: DVec2(2, 2))
        rect2 = DRect(min: DVec2(3, 3), max: DVec2(4, 4))
        intersection = rect1.intersection(with: rect2)
        XCTAssertNil(intersection)

        // no intersection with shader edge
        rect1 = DRect(min: DVec2(1, 1), max: DVec2(2, 2))
        rect2 = DRect(min: DVec2(2, 1), max: DVec2(4, 2))
        intersection = rect1.intersection(with: rect2)
        XCTAssertNil(intersection)
        
        // same rects
        rect1 = DRect(min: DVec2(1, 1), max: DVec2(2, 2))
        rect2 = DRect(min: DVec2(1, 1), max: DVec2(2, 2))
        intersection = rect1.intersection(with: rect2)
        XCTAssertNotNil(intersection)
        XCTAssertEqual(intersection, rect1)
    }

    static var allTests = [
        ("testRectangleIntersection", testRectangleIntersection),
    ]
}
