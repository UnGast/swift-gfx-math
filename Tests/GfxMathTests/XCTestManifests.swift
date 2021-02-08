import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GfxMathTests.allTests),
        testCase(VectorProtocolTests.allTests)
    ]
}
#endif
