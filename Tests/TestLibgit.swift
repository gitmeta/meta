import Foundation
@testable import meta

class TestLibgit: Libgit {
    var _repository: (() -> Void)?
    var _release: (() -> Void)?
    var _status: (() -> Void)?
    
    override func repository(_ url: URL) -> OpaquePointer? {
        _repository?()
        return nil
    }
    
    override func release(_ pointer: OpaquePointer!) {
        _release?()
    }
    
    override func status(_ repository: OpaquePointer!) -> String {
        _status?()
        return String()
    }
}
