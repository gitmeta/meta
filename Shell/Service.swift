import Foundation

@objc public protocol Service {
    func status(_ url: URL, response: @escaping ((String) -> Void))
    func commit(_ url: URL, response: @escaping ((String) -> Void))
    func reset(_ url: URL, response: @escaping ((String) -> Void))
    func pull(_ url: URL, response: @escaping ((String) -> Void))
    func push(_ url: URL, response: @escaping ((String) -> Void))
}
