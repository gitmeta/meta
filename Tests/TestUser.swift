import XCTest
@testable import TCR

class TestUser: XCTestCase {
    private var storage: TestStorage!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
    }
    
    func testFirstTime() {
        storage.error = NSError()
        XCTAssertNotNil(User.load())
        XCTAssertLessThanOrEqual(Date(), User.load().created)
    }
    
    func testLoad() {
        let user = User()
        storage._user = user
        XCTAssertTrue(user === User.load())
    }
    
    func testFirstTimeSaves() {
        let expect = expectation(description: String())
        storage.error = NSError()
        storage.saved = { expect.fulfill() }
        _ = User.load()
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateBookmarkSaves() {
        let expect = expectation(description: String())
        storage.error = NSError()
        storage.saved = { expect.fulfill() }
        User().bookmark = [:]
        waitForExpectations(timeout: 1)
    }
}
