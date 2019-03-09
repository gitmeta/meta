import AppKit

class Line: NSView {
    weak var top: NSLayoutConstraint! { didSet { top.isActive = true } }
    private(set) weak var height: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.shade.withAlphaComponent(0.6).cgColor
        isHidden = true
        
        height = heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
