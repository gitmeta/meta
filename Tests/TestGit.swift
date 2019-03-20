import XCTest
@testable import meta

class TestGit: XCTestCase {
    private var git: Git!
    private var libgit: TestLibgit!
    
    override func setUp() {
        git = Git()
        libgit = TestLibgit()
        Libgit.shared = libgit
    }
    
    func testSetRepository() {
        let expect = expectation(description: String())
        libgit._repository = { expect.fulfill() }
        git.url(URL(fileURLWithPath: "/"))
        waitForExpectations(timeout: 1)
    }
    
    func testUpdatesFreeRepository() {
        let expect = expectation(description: String())
        libgit._releaseRepository = { expect.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        git.url(URL(fileURLWithPath: "/"))
        waitForExpectations(timeout: 1)
    }
    
    func testUpdatesRemoveRepository() {
        let expect = expectation(description: String())
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        git.url(URL(fileURLWithPath: "/"))
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.03) {
            XCTAssertNil(self.git.repository)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testStatusNoRepositoryThrows() {
        XCTAssertThrowsError(try git.status { _ in } )
    }
    
    func testStatus() {
        let expectLib = expectation(description: String())
        let expectResult = expectation(description: String())
        libgit._status = { expectLib.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        try! git.status { _ in
            XCTAssertEqual(Thread.main, Thread.current)
            expectResult.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testCreateWithRepositoryThrows() {
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        XCTAssertThrowsError(try git.create(URL(fileURLWithPath: "/")) )
    }
    
    func testCreate() {
        let expect = expectation(description: String())
        libgit._create = { expect.fulfill() }
        try! git.create(URL(fileURLWithPath: "/"))
        waitForExpectations(timeout: 1)
    }
    
    func testValidate() {
        let expect = expectation(description: String())
        libgit._repository = { expect.fulfill() }
        _ = git.isRepository(URL(fileURLWithPath: "/"))
        waitForExpectations(timeout: 1)
    }
}
