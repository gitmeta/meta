import AppKit
import meta

class List: NSScrollView {
    static let shared = List()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    let folder = Folder()
    private weak var width: NSLayoutConstraint!
    private weak var title: Label!
    private let open = CGFloat(170)
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        verticalScrollElasticity = .allowed
        documentView = Flipped()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        documentView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        documentView!.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        
        width = widthAnchor.constraint(equalToConstant: open)
        width.isActive = true
        
        let title = Label(String(), color: NSColor(white: 1, alpha: 0.5), font: .systemFont(ofSize: 18, weight: .bold))
        title.maximumNumberOfLines = 2
        documentView!.addSubview(title)
        self.title = title
        
        title.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: topAnchor, constant: 45).isActive = true
        title.widthAnchor.constraint(equalToConstant: open - 14).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func clear() {
        documentView!.subviews.filter({ $0 is Document }).forEach({ $0.removeFromSuperview() })
        title.stringValue = String()
    }
    
    func update() {
        guard let name = App.shared.user.folder else { return }
        App.shared.state = .folder
        title.stringValue = name
        folder.documents(App.shared.user) {
            var top = self.topAnchor
            $0.enumerated().forEach {
                let document = Document($0.1)
                self.documentView!.addSubview(document)
                
                document.widthAnchor.constraint(equalToConstant: self.open + 10).isActive = true
                document.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                document.topAnchor.constraint(equalTo: top, constant: $0.0 == 0 ? 80 : 0).isActive = true
                top = document.bottomAnchor
            }
            if self.topAnchor !== top {
                self.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
            }
        }
    }
    
    @objc func open(_ item: Document) {
        guard item !== selected else { return }
        selected = item
        Display.shared.open(item.document)
    }
    
    @objc func toggle() {
        width.constant = Bar.shared.toggle.state == .on ? open : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    @objc func select() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.message = .local("List.open")
        panel.begin {
            if $0 == .OK {
                App.shared.user.bookmark = [panel.url!: try! panel.url!.bookmarkData(options: .withSecurityScope)]
                App.shared.clear()
            }
        }
    }
}

private class Flipped: NSView { override var isFlipped: Bool { return true } }
