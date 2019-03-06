import meta
import AppKit

class Document: NSControl {
    let document: meta.Document
    private weak var label: Label!
    
    init(_ document: meta.Document) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        
        let image = NSImageView()
        image.image = NSImage(named: {
            switch $0 {
            case is meta.Directory: return "folder"
            case is meta.Image: return "image"
            case is meta.Pdf: return "pdf"
            default: return "editable"
            }
        } (document))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let label = Label(document.name, font: .systemFont(ofSize: 12, weight: .light))
        label.lineBreakMode = .byTruncatingMiddle
        label.maximumNumberOfLines = 1
        addSubview(label)
        self.label = label
        
        image.widthAnchor.constraint(equalToConstant: 54).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: -14).isActive = true
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
