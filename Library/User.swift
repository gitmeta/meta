import Foundation

public class User: Codable {
    public var bookmark = [URL: Data]() { didSet { save() } }
    public var folder: String? { return bookmark.first?.key.lastPathComponent }
    public let created = Date()
    
    public class func load() -> User {
        return { $0 == nil ? {
            $0.save()
            return $0
        } (User()) : {
            if let data = $0.bookmark.first?.1 {
                var stale = false
                _ = (try! URL(resolvingBookmarkData: data, options: .withSecurityScope, bookmarkDataIsStale: &stale))
                    .startAccessingSecurityScopedResource()
            }
            return $0
        } ($0!) } (try? Storage.shared.user())
    }
    
    private func save() { Storage.shared.save(self) }
}
