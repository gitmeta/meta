import meta
import AppKit

class Document: NSControl {
    weak var parent: Document?
    weak var top: NSLayoutConstraint? { didSet { oldValue?.isActive = false; top?.isActive = true } }
    let document: meta.Document
    let indent: CGFloat
    private weak var label: Label!
    
    init(_ document: meta.Document, indent: CGFloat) {
        self.document = document
        self.indent = indent
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        
        let label = Label(document.name, font: .systemFont(ofSize: 12, weight: .light))
        label.lineBreakMode = .byTruncatingMiddle
        label.maximumNumberOfLines = 1
        addSubview(label)
        self.label = label
        
        let image = NSImageView()
        image.image = NSWorkspace.shared.icon(forFile: document.url.path)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyDown
        addSubview(image)
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 30 + (indent * 20)).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 2).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        if document is meta.Directory {
            let tree = Button("expand", type: .toggle, target: self, action: #selector(tree(_:)))
            tree.alternateImage = NSImage(named: "collapse")
            addSubview(tree)
            
            tree.widthAnchor.constraint(equalToConstant: 50).isActive = true
            tree.topAnchor.constraint(equalTo: topAnchor).isActive = true
            tree.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            tree.leftAnchor.constraint(equalTo: leftAnchor, constant: indent * 20).isActive = true
        }
        
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
    
    @objc private func tree(_ button: Button) {
        if button.state == .on {
            List.shared.expand(self)
        } else {
            List.shared.collapse(self)
        }
    }
}
