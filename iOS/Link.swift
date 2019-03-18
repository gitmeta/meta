import UIKit

class Link: UIButton {
    private(set) weak var width: NSLayoutConstraint!
    
    init(_ title: String, target: Any, selector: Selector) {
        super.init(frame: .zero)
        layer.cornerRadius = 4
        backgroundColor = .halo
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action: selector, for: .touchUpInside)
        setTitle(title, for: [])
        setTitleColor(.black, for: .normal)
        setTitleColor(UIColor(white: 0, alpha: 0.2), for: .highlighted)
        titleLabel!.font = .systemFont(ofSize: 15, weight: .medium)
        
        heightAnchor.constraint(equalToConstant: 34).isActive = true
        width = widthAnchor.constraint(equalToConstant: 88)
        width.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
