import XCTest
@testable import meta

class TestStatus: XCTestCase {
    private var status: Status!
    
    override func setUp() {
        status = Status()
        status.branch = "hello world"
        status.untracked = ["d", "t"]
        status.added = ["b", "a"]
        status.modified = ["x"]
        status.deleted = ["h"]
    }
    
    func testPrint() {
        XCTAssertEqual("""
hello world
untracked:
- d
- t
added:
- a
- b
modified:
- x
deleted:
- h
""", status.description)
    }
    
    func testPrintEmpty() {
        status.untracked = []
        status.modified = []
        status.added = []
        status.deleted = []
        XCTAssertEqual("""
hello world
""", status.description)
    }
    
    func testPrintOnlyDeleted() {
        status.untracked = []
        status.modified = []
        status.added = []
        XCTAssertEqual("""
hello world
deleted:
- h
""", status.description)
    }
}
