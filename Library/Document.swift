import Foundation

public protocol Document: AnyObject {
    var name: String { get }
    var url: URL { get }
}
