import Foundation

extension Folder {
    public func documents(_ result: @escaping(([Document]) -> Void)) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            let documents = {
//                $0 == nil ? nil : {
//                    $0 == nil ? nil : self?.load($0!)
//                    } (try? FileManager.default.contentsOfDirectory(at: $0!, includingPropertiesForKeys: []))
//                } (user.bookmark.first?.0) ?? []
//            DispatchQueue.main.async { result(documents) }
//        }
    }
}
