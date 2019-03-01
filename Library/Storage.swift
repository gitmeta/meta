import Foundation

class Storage {
    static var shared = Storage()
    private let queue = DispatchQueue(label: String(), qos: .background, target: .global(qos: .background))
    private let _user = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("User.tcr")
    
    func user() throws -> User {
        return try JSONDecoder().decode(User.self, from: try Data(contentsOf: _user))
    }
    
    func save(_ user: User) {
        queue.async { try! (try! JSONEncoder().encode(user)).write(to: self._user, options: .atomic) }
    }
    
    func document(_ url: URL) -> String {
        return {
            $0 == nil ? String() : String(decoding: $0!, as: UTF8.self)
        } (try? Data(contentsOf: url, options: .alwaysMapped))
    }
    
    func save(_ editable: Editable) {
        queue.async { try! Data(editable.content.utf8).write(to: editable.url, options: .atomic) }
    }
}
