import Foundation

public class Directory: Static {
    override init(_ url: URL) {
        super.init(url)
        name += "/"
    }
}
