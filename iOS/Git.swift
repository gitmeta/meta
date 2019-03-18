import UIKit

class Git: UIView {
    static let shared = Git()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        isHidden = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
