import AppKit
import meta

class Document: NSControl {
    let document: meta.Document
    private weak var label: Label!
    
    init(_ document: meta.Document) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        
        let label = Label(document.name, font: .systemFont(ofSize: 12, weight: .light))
        label.lineBreakMode = .byTruncatingMiddle
        label.maximumNumberOfLines = 1
        addSubview(label)
        self.label = label
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func mouseDown(with: NSEvent) { sendAction(#selector(List.shared.open(_:)), to: List.shared) }
    
    func update() {
        if List.shared.selected === self {
            layer!.backgroundColor = NSColor.shade.cgColor
            label.alphaValue = 0.9
        } else {
            layer!.backgroundColor = nil
            label.alphaValue = 0.6
        }
    }
}
