import Foundation
@testable import meta

class TestLibgit: Libgit {
    var _repository: (() -> Void)?
    var _releaseRepository: (() -> Void)?
    var _create: (() -> Void)?
    var _status: (() -> Void)?
    var _add: (() -> Void)?
    var _commit: (() -> Void)?
    var _history: (() -> Void)?
    
    override func repository(_ url: URL) -> OpaquePointer? {
        _repository?()
        return nil
    }
    
    override func release(repository: OpaquePointer!) {
        _releaseRepository?()
    }
    
    override func create(_ url: URL) -> OpaquePointer! {
        _create?()
        return nil
    }
    
    override func status(_ repository: OpaquePointer!) -> Status {
        _status?()
        return Status()
    }
    
    override func add(_ repository: OpaquePointer!, file: String) {
        _add?()
    }
    
    override func commit(_ message: String, credentials: Credentials, repository: OpaquePointer!) {
        _commit?()
    }
    
    override func history(_ repository: OpaquePointer!) -> [Commit] {
        _history?()
        return []
    }
}
