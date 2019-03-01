import Foundation

public class Folder {
    var timeout = TimeInterval(3)
    private(set) var queue = [Editable]()
    private let timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
    
    public init() {
        timer.resume()
        timer.setEventHandler { [weak self] in self?.fire() }
    }
    
    public func documents(_ user: User, result: @escaping(([Document]) -> Void)) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let documents = {
                $0 == nil ? nil : {
                    $0 == nil ? nil : self?.load($0!)
                } (try? FileManager.default.contentsOfDirectory(at: $0!, includingPropertiesForKeys: []))
            } (user.bookmark.first?.0) ?? []
            DispatchQueue.main.async { result(documents) }
        }
    }
    
    public func save(_ editable: Editable) {
        queue.removeAll(where: { $0 === editable })
        queue.append(editable)
        schedule()
    }
    
    public func saveAll() {
        schedule(.distantFuture)
        queue.removeAll {
            Storage.shared.save($0)
            return true
        }
    }
    
    func load(_ url: [URL]) -> [Document] {
        return url.map ({
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true ? Directory($0) : {
                switch $0.pathExtension {
                case "md": return Md($0)
                case "pdf": return Pdf($0)
                case "png", "jpg", "jpeg", "gif", "bmp": return Image($0)
                default: return Editable($0)
                }
            } ($0) as Document }).sorted(by: {
                $0 is Directory && !($1 is Directory) ? false :
                    $1 is Directory && !($0 is Directory) ? true :
                        $0.name.compare($1.name, options: .caseInsensitive) == .orderedAscending
            })
    }
    
    private func schedule(_ time: DispatchTime? = nil) { timer.schedule(deadline: time ?? .now() + timeout) }
    
    private func fire() {
        Storage.shared.save(queue.removeFirst())
        queue.isEmpty ? schedule(.distantFuture) : schedule()
    }
}
