import XCTest
@testable import meta

class TestStatus: XCTestCase {
    private var status: Status!
    
    override func setUp() {
        status = Status()
        status.remote = "asd"
        status.branch = "hello world"
        status.commit = "abc"
        status.untracked = ["d", "t"]
        status.added = ["b", "a"]
        status.modified = ["x"]
        status.deleted = ["h"]
    }
    
    func testPrint() {
        XCTAssertEqual("""
asd
hello world
abc
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
    
    func testPrintOnlyDeleted() {
        status.untracked = []
        status.modified = []
        status.added = []
        XCTAssertEqual("""
asd
hello world
abc
deleted:
- h
""", status.description)
    }
    
    func testCommitableFalse() {
        XCTAssertFalse(Status().commitable)
    }
    
    func testCommitable() {
        var status = Status()
        status.added = [String()]
        XCTAssertTrue(status.commitable)
        status = Status()
        status.deleted = [String()]
        XCTAssertTrue(status.commitable)
        status = Status()
        status.modified = [String()]
        XCTAssertTrue(status.commitable)
        status = Status()
        status.untracked = [String()]
        XCTAssertTrue(status.commitable)
    }
}
