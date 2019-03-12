import Foundation

public class User: Codable {
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
        } (User()) : $0! } (try? Storage.shared.user())
    }
    
    init() { }
    
    public required init(from: Decoder) throws {
        let container = try from.container(keyedBy: Keys.self)
        access = try? container.decode(Access.self, forKey: .access)
        rate = try container.decode(Date.self, forKey: .rate)
        created = try container.decode(Date.self, forKey: .created)
        welcome = try container.decode(Bool.self, forKey: .welcome)
    }
    
    public func encode(to: Encoder) throws {
        var container = to.container(keyedBy: Keys.self)
        try container.encode(access, forKey: .access)
        try container.encode(rate, forKey: .rate)
        try container.encode(created, forKey: .created)
        try container.encode(welcome, forKey: .welcome)
    }
    
    public var access: Access? { didSet {
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
        case access
        case rate
        case created
        case welcome
    }
}
