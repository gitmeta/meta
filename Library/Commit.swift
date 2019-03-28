public struct Commit: CustomStringConvertible {
    public var id = String()
    public var message = String()
    public var author = String()
    
    public init() { }
    
    public var description: String {
        return author.appending(":\n" + message)
    }
}
