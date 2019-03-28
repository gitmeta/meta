public struct Status: CustomStringConvertible {
    public var untracked = [String]()
    public var added = [String]()
    public var modified = [String]()
    public var deleted = [String]()
    public var branch = String()
    public var commit = String()
    public var commitable: Bool { return !untracked.isEmpty || !added.isEmpty || !modified.isEmpty || !deleted.isEmpty }
    
    public init() { }
    
    public var description: String {
        return branch.appending("\n" + commit).appending(list)
    }
    
    private var list: String {
        return list(untracked, title: "untracked")
            .appending(list(added, title: "added"))
            .appending(list(modified, title: "modified"))
            .appending(list(deleted, title: "deleted"))
    }
    
    private func list(_ list: [String], title: String) -> String {
        return list.isEmpty ? String() : {
            "\n" + $0 + ":" + list.sorted().flatMap { "\n- " + $0 }
        } (title)
    }
}
