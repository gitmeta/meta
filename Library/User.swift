import Foundation

public class User: Codable {
    public var welcome = true { didSet { save() } }
    public var ask: (() -> Void)?
    public var access: Access? { didSet { save() } }
    public internal(set) var home: Access? { didSet { save() } }
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
        home = try? container.decode(Access.self, forKey: .home)
        rate = try container.decode(Date.self, forKey: .rate)
        created = try container.decode(Date.self, forKey: .created)
        welcome = try container.decode(Bool.self, forKey: .welcome)
    }
    
    public func encode(to: Encoder) throws {
        var container = to.container(keyedBy: Keys.self)
        try container.encode(access, forKey: .access)
        try container.encode(home, forKey: .home)
        try container.encode(rate, forKey: .rate)
        try container.encode(created, forKey: .created)
        try container.encode(welcome, forKey: .welcome)
    }
    
    public func update(_ home: URL) throws {
        try {
            if $0.count == 2,
                $0[1].count > 0,
                $0[1].components(separatedBy: "/").count == 1,
                $0[0].components(separatedBy: "/").count == 1 {
                self.home = Access(home)
            } else {
                throw Exception.invalidHome
            }
        } (home.path.components(separatedBy: "/Users/"))
        /*
        if $0.count == 2,
            $0[1].count > 0 {
            App.shared.user.home = Access(panel.url!)
            App.shared.state()
            self.close()
            Alert.shared.add(.local("Activate.ready"))
        } else {
            Alert.shared.add(Exception.invalidHome)
        }
        } (panel.url!.path.components(separatedBy: "/Users/"))*/
    }
    
    private func save() {
        if Date() >= rate {
            var components = DateComponents()
            components.month = 4
            rate = Calendar.current.date(byAdding: components, to: Date())!
            DispatchQueue.main.async { [weak self] in self?.ask?() }
        }
        Storage.shared.save(self)
    }
    
    private enum Keys: CodingKey {
        case access
        case home
        case rate
        case created
        case welcome
    }
}
