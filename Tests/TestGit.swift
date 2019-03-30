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
        try! git.status { _ in expectResult.fulfill() }
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
    
    func testAdd() {
        let expect = expectation(description: String())
        libgit._add = { expect.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        try! git.add(String())
        waitForExpectations(timeout: 1)
    }
    
    func testCommit() {
        let expect = expectation(description: String())
        libgit._commit = { expect.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        try! git.commit(String(), credentials: Credentials())
        waitForExpectations(timeout: 1)
    }
    
    func testHistory() {
        let expect = expectation(description: String())
        libgit._history = { expect.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        try! git.history { _ in }
        waitForExpectations(timeout: 1)
    }
    
    func testCloneErrorsIfRepository() {
        let expect = expectation(description: String())
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        git.clone("google.com", path: URL(fileURLWithPath: "/")) {
            if case .failure(_) = $0 { expect.fulfill() }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testClone() {
        let expectClone = expectation(description: String())
        let expectReturn = expectation(description: String())
        libgit._clone = { expectClone.fulfill() }
        DispatchQueue.global(qos: .background).async {
            self.git.clone("google.com", path: URL(fileURLWithPath: "/")) {
                XCTAssertTrue(Thread.main == Thread.current)
                if case .success() = $0 { expectReturn.fulfill() }
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testClose() {
        let expect = expectation(description: String())
        libgit._releaseRepository = { expect.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        git.close()
        XCTAssertNil(git.repository)
        waitForExpectations(timeout: 1)
    }
    
    func testPush() {
        let expectPush = expectation(description: String())
        let expectResult = expectation(description: String())
        libgit._push = { expectPush.fulfill() }
        git.repository = Repository(pointer: nil, url: URL(fileURLWithPath: "/"))
        DispatchQueue.global(qos: .background).async {
            self.git.push {
                XCTAssertEqual(Thread.main, Thread.current)
                if case .success() = $0 { expectResult.fulfill() }
            }
        }
        waitForExpectations(timeout: 1)
    }
}
