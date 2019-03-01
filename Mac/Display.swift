import AppKit
import meta

class Display: NSView {
    static let shared = Display()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func clear() { subviews.forEach({ $0.removeFromSuperview() }) }
    
    func open(_ document: meta.Document) {
        clear()
        App.shared.state = .document
        switch document {
        case let document as meta.Directory: configure(Directory(document))
        case let document as meta.Image: configure(Image(document))
        case let document as meta.Pdf: configure(Pdf(document))
        case let document as Editable: configure(document)
        default: break
        }
    }
    
    private func configure(_ document: Editable) {
        let text = Text(document)
        let ruler = Ruler(text, layout: text.layoutManager as! Layout)
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.drawsBackground = false
        scroll.documentView = text
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.horizontalScrollElasticity = .none
        scroll.verticalScrollElasticity = .allowed
        scroll.verticalRulerView = ruler
        scroll.rulersVisible = true
        text.ruler = ruler
        
        configure(scroll)
        text.widthAnchor.constraint(equalTo: widthAnchor, constant: -ruler.ruleThickness).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    private func configure(_ document: NSView) {
        addSubview(document)
        
        document.topAnchor.constraint(equalTo: topAnchor).isActive = true
        document.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        document.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        document.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
