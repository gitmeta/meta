import Foundation

open class Libgit {
    public static var shared = Libgit()
    
    public init() { }
    
    open func repository(_ url: URL) -> OpaquePointer? { return nil }
    open func release(_ pointer: OpaquePointer!) {  }
    open func status(_ repository: OpaquePointer!) -> String { return String() }
}
