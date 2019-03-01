import Foundation

public class Directory: NonEditable {
    override init(_ url: URL) {
        super.init(url)
        name += "/"
    }
}
