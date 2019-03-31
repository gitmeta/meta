import Foundation

open class Libgit {
    public static var shared = Libgit()
    
    public init() { }
    
    open func repository(_ url: URL) -> OpaquePointer? { return nil }
    open func release(repository: OpaquePointer!) {  }
    open func clone(_ url: URL, path: URL) throws -> OpaquePointer! { return nil }
    open func create(_ url: URL) -> OpaquePointer! { return nil }
    open func status(_ repository: OpaquePointer!) -> Status { return Status() }
    open func add(_ repository: OpaquePointer!, file: String) { }
    open func commit(_ message: String, repository: OpaquePointer!) { }
    open func history(_ repository: OpaquePointer!) -> [Commit] { return [] }
    open func push(_ repository: OpaquePointer!) throws { }
    open func pull(_ repository: OpaquePointer!) throws { }
    open func remote(_ repository: OpaquePointer!) -> URL? { return nil }
    open func reset(_ repository: OpaquePointer!) throws { }
}
