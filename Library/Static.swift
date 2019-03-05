import Foundation

public class Static: Document {
    public internal(set) var name: String
    public let url: URL
    
    init(_ url: URL) {
        name = url.lastPathComponent
        self.url = url
    }
}
