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
    
    func testUpdateAccessSaves() {
        let expect = expectation(description: String())
        storage.saved = { expect.fulfill() }
        User().access = nil
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateHomeSaves() {
        let expect = expectation(description: String())
        storage.saved = { expect.fulfill() }
        User().home = nil
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
        user.access = nil
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
            user.access = nil
        }
        waitForExpectations(timeout: 1)
    }
    
    func testInvalidHome() {
        XCTAssertThrowsError(try User().update(URL(fileURLWithPath: "/")))
        XCTAssertThrowsError(try User().update(URL(fileURLWithPath: "/Users/")))
        XCTAssertThrowsError(try User().update(URL(fileURLWithPath: "/Users/test/alpha")))
        XCTAssertThrowsError(try User().update(URL(fileURLWithPath: "/test/Users/alpha")))
    }
    
    func testValidHome() {
        let user = User()
        let url = URL(fileURLWithPath: "/Users/test")
        XCTAssertNoThrow(try user.update(url))
        XCTAssertEqual(url, user.home?.url)
    }
    
    func testEncode() {
        let user = User()
        user.welcome = false
        user.access = Access(URL(fileURLWithPath: "/"))
        user.home = Access(URL(fileURLWithPath: "/"))
        user.created = Date(timeIntervalSince1970: 0)
        user.rate = Date(timeIntervalSince1970: 1000)
        XCTAssertEqual("""
{"home":{"url":"file:\\/\\/\\/","data":"Ym9va7wBAAAAAAQQMAAAAD0Kw8DfhjxLTH+UeMiX9hOR1ZJHtc9C9z2vlnN4aSN83AAAAAQAAAADAwAAAAgAKAAAAAABBgAADAAAAAEBAABNYWNpbnRvc2ggSEQIAAAAAAQAAEHA5oVqAw5zGAAAAAECAAAKAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkAAGZpbGU6Ly8vCAAAAAQDAAAAUAZeOgAAACQAAAABAQAAOUEzQ0Y1QjgtRTdDMC00QThFLUI4QzEtQkNBQzRFMjJCMjVCGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+\\/\\/\\/\\/AQAAAAAAAAANAAAABBAAABAAAAAAAAAAEBAAADwAAAAAAAAAIBAAABgAAAAAAAAAQBAAACwAAAAAAAAAAiAAAMgAAAAAAAAABSAAAFwAAAAAAAAAECAAABgAAAAAAAAAESAAAHwAAAAAAAAAEiAAAGwAAAAAAAAAEyAAACwAAAAAAAAAICAAAKgAAAAAAAAAMCAAANQAAAAAAAAAENAAAAQAAAAAAAAA"},"access":{"url":"file:\\/\\/\\/","data":"Ym9va7wBAAAAAAQQMAAAAD0Kw8DfhjxLTH+UeMiX9hOR1ZJHtc9C9z2vlnN4aSN83AAAAAQAAAADAwAAAAgAKAAAAAABBgAADAAAAAEBAABNYWNpbnRvc2ggSEQIAAAAAAQAAEHA5oVqAw5zGAAAAAECAAAKAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAAIAAAAAQkAAGZpbGU6Ly8vCAAAAAQDAAAAUAZeOgAAACQAAAABAQAAOUEzQ0Y1QjgtRTdDMC00QThFLUI4QzEtQkNBQzRFMjJCMjVCGAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEAAC8AAAAAAAAAAQUAAKgAAAD+\\/\\/\\/\\/AQAAAAAAAAANAAAABBAAABAAAAAAAAAAEBAAADwAAAAAAAAAIBAAABgAAAAAAAAAQBAAACwAAAAAAAAAAiAAAMgAAAAAAAAABSAAAFwAAAAAAAAAECAAABgAAAAAAAAAESAAAHwAAAAAAAAAEiAAAGwAAAAAAAAAEyAAACwAAAAAAAAAICAAAKgAAAAAAAAAMCAAANQAAAAAAAAAENAAAAQAAAAAAAAA"},"created":-978307200,"welcome":false,"rate":-978306200}
""", String(decoding: try JSONEncoder().encode(user), as: UTF8.self))
    }
    
    func testDecode() {
        let decoded = try! JSONDecoder().decode(User.self, from: Data("""
{"rate":-978306200,"created":-978307200,"access":{"url":"file:\\/\\/\\/","data":""},"home":{"url":"file:\\/\\/\\/","data":""},"welcome":false}
""".utf8))
        XCTAssertEqual(URL(fileURLWithPath: "/"), decoded.access?.url)
        XCTAssertEqual(URL(fileURLWithPath: "/"), decoded.home?.url)
        XCTAssertEqual(Date(timeIntervalSince1970: 0), decoded.created)
        XCTAssertEqual(Date(timeIntervalSince1970: 1000), decoded.rate)
        XCTAssertEqual(false, decoded.welcome)
    }
    
    func testEmptyDecode() {
        XCTAssertNoThrow(try JSONDecoder().decode(User.self, from: Data("""
{"rate":0,"created":0,"welcome":false}
""".utf8)))
    }
    
    func testEmptyEncode() {
        XCTAssertNoThrow(try JSONEncoder().encode(User()))
    }
}
