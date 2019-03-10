import AppKit

class Console: NSScrollView {
    static let shared = Console()
    private weak var height: NSLayoutConstraint!
    private let open = CGFloat(250)
    private let format = DateFormatter()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = NSColor.shade.withAlphaComponent(0.4)
        documentView = {
            $0.drawsBackground = false
            $0.isRichText = false
            $0.font = .light(12)
            $0.textColor = NSColor(white: 1, alpha: 0.7)
            $0.textContainerInset = NSSize(width: 10, height: 10)
            $0.isVerticallyResizable = true
            $0.isHorizontallyResizable = true
            $0.isEditable = false
            return $0
        } (NSTextView())
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScrollElasticity = .none
        verticalScrollElasticity = .allowed
        height = heightAnchor.constraint(equalToConstant: open)
        height.isActive = true
        format.dateStyle = .none
        format.timeStyle = .medium
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func log(_ message: String) {
        (documentView as! NSTextView).string += format.string(from: Date()) + " " + message + "\n"
        (documentView as! NSTextView).scrollRangeToVisible(NSMakeRange((documentView as! NSTextView).string.count, 0))
    }
    
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
