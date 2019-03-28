import Foundation

open class Libgit {
    public static var shared = Libgit()
    
    public init() { }
    
    open func repository(_ url: URL) -> OpaquePointer? { return nil }
    open func release(repository: OpaquePointer!) {  }
    open func clone(_ url: URL, path: URL) -> OpaquePointer? { return nil }
    open func create(_ url: URL) -> OpaquePointer! { return nil }
    open func status(_ repository: OpaquePointer!) -> Status { return Status() }
    open func add(_ repository: OpaquePointer!, file: String) { }
    open func commit(_ message: String, credentials: Credentials, repository: OpaquePointer!) { }
    open func history(_ repository: OpaquePointer!) -> [Commit] { return [] }
}
