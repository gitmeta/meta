import XCTest
@testable import meta

class TestDocumentCreate: XCTestCase {
    private var user: User!
    private var folder: Folder!
    private var storage: TestStorage!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
        user = User()
        folder = Folder()
        user.bookmark = [URL(fileURLWithPath: NSTemporaryDirectory()) : Data()]
    }
    
    override func tearDown() {
        try? FileManager.default.contentsOfDirectory(atPath: URL(fileURLWithPath: NSTemporaryDirectory()).path).forEach {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent($0))
        }
    }
    
    func testCreate() {
        XCTAssertNoThrow(try folder.create("hello.txt", user: user))
        XCTAssertTrue(FileManager.default.fileExists(atPath: URL(fileURLWithPath:
            NSTemporaryDirectory()).appendingPathComponent("hello.txt").path))
    }
    
    func testDuplicateThrows() {
        try! folder.create("hello.txt", user: user)
        XCTAssertThrowsError(try folder.create("hello.txt", user: user))
    }
}
