import Foundation

public class Document {
    public let url: URL
    public let name: String
    
    init(_ url: URL) {
        self.url = url
        name = url.lastPathComponent
    }
}
