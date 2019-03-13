import XCTest
@testable import meta

class TestUser_Access: XCTestCase {
    override func setUp() {
        Storage.shared = TestStorage()
    }
    
    func testRemoveAccessNotValid() {
        let user = User()
        user.access = Access(URL(fileURLWithPath: "/test"))
        user.validate()
        XCTAssertNil(user.access)
    }
    
    func testRemoveHomeNotValid() {
        let user = User()
        user.home = Access(URL(fileURLWithPath: "/test"))
        user.validate()
        XCTAssertNil(user.home)
    }
    
    func testNotRemoveIfValid() {
        let user = User()
        user.home = Access(URL(fileURLWithPath: "/"))
        user.access = Access(URL(fileURLWithPath: "/"))
        user.validate()
        XCTAssertNotNil(user.home)
        XCTAssertNotNil(user.access)
    }
}
