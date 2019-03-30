import XCTest
@testable import meta

class TestCredentials: XCTestCase {
    override func setUp() {
        Credentials.keychain = false
    }
    
    func testNonEmpty() {
        XCTAssertThrowsError(try Credentials(String(), email: String(), password: "a"))
        XCTAssertThrowsError(try Credentials(String(), email: "test@mail.com", password: "a"))
        XCTAssertThrowsError(try Credentials("test", email: String(), password: "a"))
        XCTAssertThrowsError(try Credentials("test", email: "test@mail.com", password: String()))
    }
    
    func testAt() {
        XCTAssertThrowsError(try Credentials("test", email: "testmail.com", password: "a"))
        XCTAssertThrowsError(try Credentials("test", email: "test@@mail.com", password: "a"))
    }
    
    func testDot() {
        XCTAssertThrowsError(try Credentials("test", email: "test@mailcom", password: "a"))
        XCTAssertThrowsError(try Credentials("test", email: "test@mailcom.", password: "a"))
        XCTAssertThrowsError(try Credentials("test", email: "test@.mailcom", password: "a"))
    }
    
    func testWeird() {
        XCTAssertThrowsError(try Credentials("test", email: "test@ mail.com", password: "a"))
    }
}
