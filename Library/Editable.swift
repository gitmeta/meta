import Foundation

public class Editable: Document {
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
    
    var cache: String?
    
    public func refresh() {
        cache = nil
    }
}
