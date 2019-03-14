import Foundation

public struct Access: Codable {
    public let url: URL
    public let data: Data
    
    public init(_ url: URL) {
        data = (try? url.bookmarkData(options: .withSecurityScope)) ?? Data()
        self.url = url
    }
}
