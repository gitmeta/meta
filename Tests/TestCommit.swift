import XCTest
@testable import meta

class TestCommit: XCTestCase {
    func testDescription() {
        var commit = Commit()
        commit.id = "lorem ipsum"
        commit.author = "test"
        commit.message = "this is a test"
        XCTAssertEqual("""
lorem ipsum - test
this is a test
""", commit.description)
    }
}
