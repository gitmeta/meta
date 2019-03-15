import Foundation

public struct Access: Codable {
    public let url: URL
    public let data: Data
    
    public init(_ url: URL, data: Data) {
        self.url = url
        self.data = data
    }
}
