import Foundation
@testable import meta

class TestLibgit: Libgit {
    var _repository: (() -> Void)?
    var _releaseRepository: (() -> Void)?
    var _status: (() -> Void)?
    
    override func repository(_ url: URL) -> OpaquePointer? {
        _repository?()
        return nil
    }
    
    override func release(repository: OpaquePointer!) {
        _releaseRepository?()
    }
    
    override func status(_ repository: OpaquePointer!) -> String {
        _status?()
        return String()
    }
}
