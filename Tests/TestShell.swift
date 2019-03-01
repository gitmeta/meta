import XCTest
@testable import TCR

class TestShell: XCTestCase {
    func testNoThrows() {
        XCTAssertNoThrow(try Shell.message("pwd"))
    }
    
    func testCommunication() {
        XCTAssertEqual("hello world", try! Shell.message("echo hello world"))
    }
}
