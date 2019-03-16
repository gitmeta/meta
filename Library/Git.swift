import Foundation

public class Git {
    var repository: Repository?
    private let queue = DispatchQueue(label: String(), qos: .background, target: .global(qos: .background))
    
    public init() { }
    
    public func url(_ url: URL) {
        queue.async { [weak self] in
            if let current = self?.repository {
                Libgit.shared.release(current.pointer)
            }
            guard let pointer = Libgit.shared.repository(url) else { return }
            self?.repository = Repository(pointer: pointer, url: url)
        }
    }
    
    public func status(_ result: @escaping((String) -> Void)) throws {
        guard let repository = self.repository else { throw GitError.noRepository }
        queue.async {
            DispatchQueue.main.async {
                result(Libgit.shared.status(repository.pointer))
            }
        }
    }
}
