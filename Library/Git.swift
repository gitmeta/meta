import Foundation

public class Git {
    var repository: Repository?
    private let queue = DispatchQueue(label: String(), qos: .background, target: .global(qos: .background))
    
    public init() { }
    
    public func url(_ url: URL) {
        queue.async { [weak self] in
            if let current = self?.repository {
                Libgit.shared.release(repository: current.pointer)
            }
            self?.repository = {
               $0 == nil ? nil : Repository(pointer: $0, url: url)
            } (Libgit.shared.repository(url))
        }
    }
    
    public func status(_ result: @escaping((String) -> Void)) throws {
        guard let repository = self.repository else { throw Exception.noRepository }
        queue.async {
            DispatchQueue.main.async {
                result(Libgit.shared.status(repository.pointer))
            }
        }
    }
}
