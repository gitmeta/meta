public class Git {
    public init() { }
    
    public func commit(_ user: User) -> String {
        return try! Shell.message("git add .", location: user.bookmark.first!.0) + "\n"
            + (try! Shell.message("git commit -m \"meta\"", location: user.bookmark.first!.0)) + "\n"
    }
    
    public func reset(_ user: User) -> String {
        return try! Shell.message("git reset --hard", location: user.bookmark.first!.0) + "\n"
    }
    
    public func status(_ user: User) -> String { return try! Shell.message("git status", location: user.bookmark.first!.0) + "\n" }
    public func pull(_ user: User) -> String { return try! Shell.message("git pull", location: user.bookmark.first!.0) + "\n" }
    public func push(_ user: User) -> String { return try! Shell.message("git push", location: user.bookmark.first!.0) + "\n" }
}
