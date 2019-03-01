import AppKit

class Button: NSButton {
    init(_ name: String, type: NSButton.ButtonType = .momentaryChange, target: AnyObject, action: Selector) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setButtonType(type)
        imageScaling = .scaleNone
        isBordered = false
        image = NSImage(named: name)
        self.target = target
        self.action = action
    }
    
    required init?(coder: NSCoder) { return nil }
}
