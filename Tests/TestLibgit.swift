import Foundation
@testable import meta

class TestLibgit: Libgit {
    var _repository: (() -> Void)!
    var _releaseRepository: (() -> Void)!
    var _create: (() -> Void)!
    var _status: (() -> Void)!
    var _add: (() -> Void)!
    var _commit: (() -> Void)!
    var _history: (() -> Void)!
    var _clone: (() -> Void)!
    var _push: (() -> Void)!
    var _pull: (() -> Void)!
    var _reset: (() -> Void)!
    
    override func repository(_ url: URL) -> OpaquePointer? { _repository?(); return nil }
    override func release(repository: OpaquePointer!) { _releaseRepository?() }
    override func clone(_ url: URL, path: URL) -> OpaquePointer? { _clone(); return nil }
    override func create(_ url: URL) -> OpaquePointer! { _create(); return nil }
    override func status(_ repository: OpaquePointer!) -> Status { _status(); return Status() }
    override func add(_ repository: OpaquePointer!, file: String) { _add() }
    override func commit(_ message: String, repository: OpaquePointer!) { _commit() }
    override func history(_ repository: OpaquePointer!) -> [Commit] { _history(); return [] }
    override func push(_ repository: OpaquePointer!) { _push() }
    override func pull(_ repository: OpaquePointer!) throws { _pull() }
    override func reset(_ repository: OpaquePointer!) throws { _reset() }
}
