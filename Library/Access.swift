import Foundation

public class Access: Codable {
    public let url: URL
    public let data: Data
    
    public init(_ url: URL) {
        data = (try? url.bookmarkData(options: .withSecurityScope)) ?? Data()
        self.url = url
    }
    
    public func activate() {
        var stale = false
        _ = (try? URL(resolvingBookmarkData: data, options: .withSecurityScope, bookmarkDataIsStale:
            &stale))?.startAccessingSecurityScopedResource()
    }
}
