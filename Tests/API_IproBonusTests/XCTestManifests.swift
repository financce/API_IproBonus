import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(API_IproBonusTests.allTests),
    ]
}
#endif
