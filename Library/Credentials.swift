public struct Credentials: Codable {
    public var name = String()
    public var email = String()
    
    public init(_ name: String, email: String) throws {
        guard !name.isEmpty else { throw Exception.invalidName }
        
        try email.forEach {
            switch $0 {
            case " ", "*", "\\", "/", "$", "%", ";", ",", "!", "?", "~": throw Exception.invalidEmail
            default: break
            }
        }
        
        let at = email.components(separatedBy: "@")
        let dot = at.last!.components(separatedBy: ".")
        guard at.count == 2, dot.count > 1, !dot.first!.isEmpty, !dot.last!.isEmpty else { throw Exception.invalidEmail }
        
        self.name = name
        self.email = email
    }
    
    init() { }
}
