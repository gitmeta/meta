import Foundation

public class User: Codable {
    public var folder: String? { return bookmark.first?.key.lastPathComponent }
    public var welcome = true { didSet { save() } }
    public var ask: (() -> Void)?
    var rate = Date()
    var created = Date()
    
    public class func load() -> User {
        return { $0 == nil ? {
            var components = DateComponents()
            components.day = 3
            $0.rate = Calendar.current.date(byAdding: components, to: Date())!
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
    
    init() { }
    
    public required init(from: Decoder) throws {
        let container = try from.container(keyedBy: Keys.self)
        bookmark = try container.decode([URL: Data].self, forKey: .bookmark)
        rate = try container.decode(Date.self, forKey: .rate)
        created = try container.decode(Date.self, forKey: .created)
        welcome = try container.decode(Bool.self, forKey: .welcome)
    }
    
    public func encode(to: Encoder) throws {
        var container = to.container(keyedBy: Keys.self)
        try container.encode(bookmark, forKey: .bookmark)
        try container.encode(rate, forKey: .rate)
        try container.encode(created, forKey: .created)
        try container.encode(welcome, forKey: .welcome)
    }
    
    public var bookmark = [URL: Data]() { didSet {
        if Date() >= rate {
            var components = DateComponents()
            components.month = 4
            rate = Calendar.current.date(byAdding: components, to: Date())!
            DispatchQueue.main.async { [weak self] in self?.ask?() }
        }
        save()
    } }
    
    private func save() { Storage.shared.save(self) }
    
    private enum Keys: CodingKey {
        case bookmark
        case rate
        case created
        case welcome
    }
}
