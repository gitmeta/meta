import XCTest
@testable import meta

class TestCommit: XCTestCase {
    func testDescription() {
        var commit = Commit()
        commit.author = "test"
        commit.message = "this is a test"
        XCTAssertEqual("""
test:
this is a test
""", commit.description)
    }
}
