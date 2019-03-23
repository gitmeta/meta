public struct Status: CustomStringConvertible {
    public var untracked = [String]()
    public var added = [String]()
    public var modified = [String]()
    public var deleted = [String]()
    public var branch = String()
    
    public init() { }
    
    public var description: String {
        return String()
    }
}
