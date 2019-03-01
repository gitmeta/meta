import Foundation

public class Editable: Document {
    public let name: String
    let url: URL
    private var cache: String?
    
    public var content: String {
        get {
            return cache != nil ? cache! : {
                cache = $0
                return $0
            } (Storage.shared.document(url))
        } set {
            cache = newValue
        }
    }
    
    init(_ url: URL) {
        name = url.lastPathComponent
        self.url = url
    }
}
