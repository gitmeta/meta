import Foundation

public class Credentials: Codable {
    public var user = String()
    public var email = String()
    private let query = [kSecClass as String: kSecClassGenericPassword,
                         kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                         kSecAttrAccount as String: Data("user".utf8),
                         kSecAttrService as String: Data("meta".utf8)] as [String: Any]
    
    public init(_ user: String, email: String) throws {
        guard !user.isEmpty else { throw Exception.invalidUser }
        
        try email.forEach {
            switch $0 {
            case " ", "*", "\\", "/", "$", "%", ";", ",", "!", "?", "~": throw Exception.invalidEmail
            default: break
            }
        }
        
        let at = email.components(separatedBy: "@")
        let dot = at.last!.components(separatedBy: ".")
        guard at.count == 2, dot.count > 1, !dot.first!.isEmpty, !dot.last!.isEmpty else { throw Exception.invalidEmail }
        
        self.user = user
        self.email = email
    }
    
    init() { }
    
    public required init(from: Decoder) throws {
        let container = try from.container(keyedBy: Keys.self)
        user = try container.decode(String.self, forKey: .user)
        email = try container.decode(String.self, forKey: .email)
    }
    
    public func encode(to: Encoder) throws {
        var container = to.container(keyedBy: Keys.self)
        try container.encode(user, forKey: .user)
        try container.encode(email, forKey: .email)
    }
    
    public var password: String? {
        get {
            var result: CFTypeRef?
            var query = self.query
            query[kSecReturnData as String] = true
            query[kSecReturnAttributes as String] = true
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            SecItemCopyMatching(query as CFDictionary, &result)
            if let data = (result as? [String: Any])?[String(kSecValueData)] as? Data {
                return String(decoding: data, as: UTF8.self)
            }
            return nil
        }
        set {
            if newValue == nil {
                if password != nil {
                    SecItemDelete(query as CFDictionary)
                }
            } else if password != nil {
                SecItemUpdate(query as CFDictionary, [kSecValueData as String: Data(newValue!.utf8)] as CFDictionary)
            } else {
                var query = self.query
                query[kSecValueData as String] = Data(newValue!.utf8)
                SecItemAdd(query as CFDictionary, nil)
            }
        }
    }
    
    private enum Keys: CodingKey {
        case user
        case email
    }
}
