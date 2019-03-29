import XCTest
@testable import meta

class TestFolder: XCTestCase {
    private var storage: TestStorage!
    private var folder: Folder!
    private var editable: Editable!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
        folder = Folder()
        folder.timeout = 0
        editable = Editable(URL(fileURLWithPath: "file.json"))
    }
    
    func testSaveUpdates() {
        let expect = expectation(description: String())
        storage.saved = {
            XCTAssertTrue(self.folder.queue.isEmpty)
            expect.fulfill()
        }
        folder.save(editable)
        waitForExpectations(timeout: 1)
    }
    
    func testSaveMultiple() {
        var count = 0
        let expect = expectation(description: String())
        storage.saved = {
            count += 1
            if count == 2 {
                expect.fulfill()
            }
        }
        folder.save(editable)
        folder.save(Editable(URL(fileURLWithPath: "file.json")))
        waitForExpectations(timeout: 1)
    }
    
    func testReplaceOnSave() {
        folder.timeout = 1000
        folder.save(editable)
        folder.save(editable)
        XCTAssertEqual(1, folder.queue.count)
    }
    
    func testSaveAll() {
        let expect = expectation(description: String())
        folder.timeout = 1000
        folder.save(editable)
        folder.save(Editable(URL(fileURLWithPath: "file.json")))
        folder.save(Editable(URL(fileURLWithPath: "A.json")))
        folder.save(Editable(URL(fileURLWithPath: "B.json")))
        folder.save(Editable(URL(fileURLWithPath: "C.json")))
        folder.save(Editable(URL(fileURLWithPath: "D.json")))
        var count = 0
        storage.saved = {
            count += 1
            if count == 6 {
                expect.fulfill()
            }
        }
        folder.saveAll()
        waitForExpectations(timeout: 1)
    }
    
    func testClear() {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
        let url = directory.appendingPathComponent("file.json")
        try! Data().write(to: url)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        folder.clear(directory)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
    }
}
