import AppKit
import TCR

class Scroll: NSScrollView {
    static let shared = Scroll()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScrollElasticity = .none
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func open(_ document: TCR.Document) {
        clear()
        switch document {
        case let document as TCR.Directory: configure(Directory(document))
        case let document as TCR.Image: configure(Image(document))
        case let document as TCR.Pdf: configure(Pdf(document))
        case let document as Editable: configure(document)
        default: break
        }
    }
    
    func clear() {
        documentView = nil
        verticalRulerView = nil
        rulersVisible = false
        verticalScrollElasticity = .none
    }
    
    private func configure(_ document: Editable) {
        let text = Text(document)
        let ruler = Ruler(text, layout: text.layoutManager as! Layout)
        text.ruler = ruler
        documentView = text
        verticalRulerView = ruler
        rulersVisible = true
        verticalScrollElasticity = .allowed
        
        text.widthAnchor.constraint(equalTo: widthAnchor, constant: -ruler.ruleThickness).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        App.shared.makeFirstResponder(text)
    }
    
    private func configure(_ document: NSView) {
        documentView = document
        documentView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        documentView!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
