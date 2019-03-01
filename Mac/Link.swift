import AppKit

class Link: NSButton {
    private(set) weak var width: NSLayoutConstraint!
    private(set) weak var height: NSLayoutConstraint!
    
    init(_ title: String, background: NSColor = .clear, text: NSColor = .white, target: AnyObject, action: Selector) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = background.cgColor
        layer!.cornerRadius = 6
        setButtonType(.momentaryChange)
        isBordered = false
        attributedTitle = NSAttributedString(string: title, attributes: [.font: NSFont.bold(16), .foregroundColor: text])
        self.target = target
        self.action = action
        width = widthAnchor.constraint(equalToConstant: 108)
        height = heightAnchor.constraint(equalToConstant: 38)
        width.isActive = true
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
