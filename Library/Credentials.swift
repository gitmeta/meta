public struct Credentials: Codable {
    public let name: String
    public let email: String
    
    init(_ name: String, email: String) {
        self.name = name
        self.email = email
    }
}
