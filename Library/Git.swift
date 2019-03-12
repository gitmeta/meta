public class Git {
    public init() { }
    
    public func commit(_ user: User) -> String {
        return try! Shell.message("git add .", location: user.access?.url)
            + (try! Shell.message("git commit -m \"meta\"", location: user.access?.url))
    }
    
    public func status(_ user: User) -> String { return try! Shell.message("git status", location: user.access?.url) }
    public func reset(_ user: User) -> String { return try! Shell.message("git reset --hard", location: user.access?.url) }
    public func pull(_ user: User) -> String { return try! Shell.message("git pull", location: user.access?.url) }
    public func push(_ user: User) -> String { return try! Shell.message("git push", location: user.access?.url) }
}
