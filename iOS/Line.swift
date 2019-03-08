import UIKit

class Line: UIView {
    weak var top: NSLayoutConstraint! { didSet { top.isActive = true } }
    private(set) weak var height: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .shade
        isHidden = true
        
        height = heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
