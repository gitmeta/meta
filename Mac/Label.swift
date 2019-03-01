import AppKit

class Label: NSTextField {
    init(_ string: String = String(), color: NSColor = .white, font: NSFont = .light(16), align: NSTextAlignment = .left) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        textColor = color
        isBezeled = false
        isEditable = false
        stringValue = string
        alignment = align
        self.font = font
    }
    
    required init?(coder: NSCoder) { return nil }
}
