import meta
import AppKit

class Document: NSControl {
    let document: meta.Document
    private weak var label: Label!
    private weak var tree: Button?
    
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
        
        let image = NSImageView()
        image.image = NSWorkspace.shared.icon(forFile: document.url.path)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyDown
        addSubview(image)
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 2).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        if document is meta.Directory {
            let tree = Button("expand", type: .toggle, target: List.shared, action: #selector(List.shared.toggle))
            tree.alternateImage = NSImage(named: "collapse")
            addSubview(tree)
            self.tree = tree
            
            tree.widthAnchor.constraint(equalToConstant: 50).isActive = true
            tree.topAnchor.constraint(equalTo: topAnchor).isActive = true
            tree.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            tree.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
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
}
