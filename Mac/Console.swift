import AppKit

class Console: NSView {
    static let shared = Console()
    private weak var height: NSLayoutConstraint!
    private let open = CGFloat(180)
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.shade.withAlphaComponent(0.4).cgColor
        
        height = heightAnchor.constraint(equalToConstant: open)
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc func toggle() {
        Menu.shared.console.state = Bar.shared.console.state == .on ? .on : .off
        height.constant = Bar.shared.console.state == .on ? open : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
}
