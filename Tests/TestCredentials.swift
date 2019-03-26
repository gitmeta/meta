import XCTest
@testable import meta

class TestCredentials: XCTestCase {
    func testNonEmpty() {
        XCTAssertThrowsError(try Credentials(String(), email: String()))
        XCTAssertThrowsError(try Credentials(String(), email: "test@mail.com"))
        XCTAssertThrowsError(try Credentials("test", email: String()))
    }
    
    func testAt() {
        XCTAssertThrowsError(try Credentials("test", email: "testmail.com"))
        XCTAssertThrowsError(try Credentials("test", email: "test@@mail.com"))
    }
    
    func testDot() {
        XCTAssertThrowsError(try Credentials("test", email: "test@mailcom"))
        XCTAssertThrowsError(try Credentials("test", email: "test@mailcom."))
        XCTAssertThrowsError(try Credentials("test", email: "test@.mailcom"))
    }
}
