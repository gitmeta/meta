import AppKit
import TCR

class Text: NSTextView {
    weak var ruler: Ruler?
    private weak var document: Editable?
    private weak var height: NSLayoutConstraint!
    
    init(_ document: Editable) {
        let storage = Storage()
        super.init(frame: .zero, textContainer: {
            storage.addLayoutManager($1)
            $1.addTextContainer($0)
            $0.lineBreakMode = .byCharWrapping
            return $0
        } (NSTextContainer(), Layout()) )
        translatesAutoresizingMaskIntoConstraints = false
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        insertionPointColor = .halo
        font = .light(Skin.font)
        string = document.content
        textContainerInset = NSSize(width: 20, height: 30)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
        adjust()
        self.document = document
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width += 2
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        document?.content = string
        adjust()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let document = self?.document else { return }
            Side.shared.folder.save(document)
        }
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        DispatchQueue.main.async { [weak self] in self?.adjust() }
    }
    
    override func updateRuler() { ruler?.setNeedsDisplay(visibleRect) }
    
    private func adjust() {
        textContainer!.size.width = Scroll.shared.frame.width - (textContainerInset.width * 2) - Ruler.thickness
        layoutManager!.ensureLayout(for: textContainer!)
        height.constant = layoutManager!.usedRect(for: textContainer!).size.height + (textContainerInset.height * 2)
        DispatchQueue.main.async { [weak self] in self?.updateRuler() }
    }
}
