import Foundation

public class Git {
    public internal(set) var repository: Repository?
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
    
    public func clone(_ url: URL, path: URL, result: @escaping((Result<Void, Error>) -> Void)) {
        guard self.repository == nil else { return result(.failure(Exception.alreadyRepository)) }
        queue.async {
            let response = Result { [weak self] in
                guard let self = self else { return }
                self.repository = Repository(pointer: try Libgit.shared.clone(url, path: path), url: url)
            }
            DispatchQueue.main.async { result(response) }
        }
    }
    
    public func create(_ url: URL) throws {
        guard self.repository == nil else { throw Exception.alreadyRepository }
        queue.async { [weak self] in
            self?.repository = Repository(pointer: Libgit.shared.create(url), url: url)
        }
    }
    
    public func status(_ result: @escaping((Status) -> Void)) throws {
        guard let repository = self.repository else { throw Exception.noRepository }
        queue.async {
            result(Libgit.shared.status(repository.pointer))
        }
    }
    
    public func add(_ file: String) throws {
        guard let repository = self.repository else { throw Exception.noRepository }
        queue.async {
            Libgit.shared.add(repository.pointer, file: file)
        }
    }
    
    public func commit(_ message: String, credentials: Credentials) throws {
        guard let repository = self.repository else { throw Exception.noRepository }
        queue.async {
            Libgit.shared.commit(message, credentials: credentials, repository: repository.pointer)
        }
    }
    
    public func history(_ result: @escaping(([Commit]) -> Void)) throws {
        guard let repository = self.repository else { throw Exception.noRepository }
        queue.async {
            result(Libgit.shared.history(repository.pointer))
        }
    }
    
    
}
