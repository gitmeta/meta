import XCTest
@testable import meta

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
    
    func testRateDate() {
        var components = DateComponents()
        components.day = 2
        storage.error = NSError()
        XCTAssertNotNil(User.load())
        XCTAssertLessThan(Calendar.current.date(byAdding: components, to: Date())!, User.load().rate)
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
        storage.saved = { expect.fulfill() }
        User().bookmark = [:]
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateWelcomeSaves() {
        let expect = expectation(description: String())
        storage.saved = { expect.fulfill() }
        User().welcome = false
        waitForExpectations(timeout: 1)
    }
    
    func testShouldRate() {
        let expect = expectation(description: String())
        let user = User()
        user.rate = Date()
        user.ask = { expect.fulfill() }
        user.bookmark = [:]
        var components = DateComponents()
        components.month = 3
        XCTAssertLessThan(Calendar.current.date(byAdding: components, to: Date())!, user.rate)
        waitForExpectations(timeout: 1)
    }
    
    func testRateNotify() {
        let expect = expectation(description: String())
        let user = User()
        user.rate = Date()
        user.ask = {
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos: .background).async {
            user.bookmark = [:]
        }
        waitForExpectations(timeout: 1)
    }
    
    func testEncode() {
        let user = User()
        user.bookmark = [URL(fileURLWithPath:"/"): Data()]
        user.created = Date(timeIntervalSince1970:0)
        user.rate = Date(timeIntervalSince1970:1000)
        user.welcome = false
        XCTAssertEqual("""
{"created":-978307200,"bookmark":["file:\\/\\/\\/",""],"welcome":false,"rate":-978306200}
""", String(decoding: try JSONEncoder().encode(user), as: UTF8.self))
    }
    
    func testDecode() {
        let decoded = try! JSONDecoder().decode(User.self, from: Data("""
{"rate":-978306200,"created":-978307200,"bookmark":["file:\\/\\/\\/",""],"welcome":false}
""".utf8))
        XCTAssertEqual([URL(fileURLWithPath:"/"): Data()], decoded.bookmark)
        XCTAssertEqual(Date(timeIntervalSince1970:0), decoded.created)
        XCTAssertEqual(Date(timeIntervalSince1970:1000), decoded.rate)
        XCTAssertEqual(false, decoded.welcome)
    }
}
