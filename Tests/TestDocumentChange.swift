import XCTest
@testable import meta

class TestDocumentChange: XCTestCase {
    private var user: User!
    private var folder: Folder!
    private var storage: TestStorage!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
        user = User()
        folder = Folder()
        user.access = Access(URL(fileURLWithPath: NSTemporaryDirectory()), data: Data())
        clear()
    }
    
    override func tearDown() {
        clear()
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
    
    func testDelete() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("hello.txt")
        try! folder.create("hello.txt", user: user)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        try! folder.delete(Editable(url))
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
    
    func testThrowsIfNotExisting() {
        XCTAssertThrowsError(try folder.delete(Editable(
            URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("hello.txt"))))
    }
    
    private func clear() {
        try? FileManager.default.contentsOfDirectory(atPath: URL(fileURLWithPath: NSTemporaryDirectory()).path).forEach {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent($0))
        }
    }
}
