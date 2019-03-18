import Foundation

open class Libgit {
    public static var shared = Libgit()
    
    public init() { }
    
    open func repository(_ url: URL) -> OpaquePointer? { return nil }
    open func release(repository: OpaquePointer!) {  }
    open func create(_ url: URL) -> OpaquePointer! { return nil }
    open func status(_ repository: OpaquePointer!) -> String { return String() }
}
