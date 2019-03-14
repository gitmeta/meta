import Foundation

@objc public protocol Service {
    func activate(_ url: URL, data: Data)
    func status(_ response: @escaping ((String) -> Void))
    func commit(_ response: @escaping ((String) -> Void))
    func reset(_ response: @escaping ((String) -> Void))
    func pull(_ response: @escaping ((String) -> Void))
    func push(_ response: @escaping ((String) -> Void))
}
