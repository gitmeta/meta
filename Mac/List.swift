import meta
import AppKit

class List: NSScrollView {
    static let shared = List()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    let folder = Folder()
    private weak var width: NSLayoutConstraint!
    private weak var title: Label!
    private weak var bottom: NSLayoutConstraint? { didSet { oldValue?.isActive = false; bottom?.isActive = true } }
    private let open = CGFloat(350)
    
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
        
        let title = Label(String(), color: .halo, font: .systemFont(ofSize: 18, weight: .regular))
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
        guard let name = App.shared.user.access?.url.lastPathComponent else { return }
        App.shared.state = .folder
        title.stringValue = name
        folder.documents(App.shared.user) {
            guard let last = self.render($0, origin: self.topAnchor, margin: 80, parent: nil) else { return }
            self.align(last)
        }
    }
    
    func expand(_ document: Document) {
        folder.documents(document.document.url) {
            let sibling = self.documentView!.subviews.compactMap({ $0 as? Document }).first(where: { $0.top?.secondItem === document })
            guard let last = self.render($0, origin: document.bottomAnchor, margin: 0, parent: document) else { return }
            if let sibling = sibling {
                sibling.top = sibling.topAnchor.constraint(equalTo: last.bottomAnchor)
            } else {
                self.align(last)
            }
        }
    }
    
    func collapse(_ document: Document) {
        if let sibling = documentView!.subviews.compactMap({ $0 as? Document }).filter({ $0.parent !== document }).first(where:
            { ($0.top?.secondItem as? Document)?.parent === document }) {
            sibling.top = sibling.topAnchor.constraint(equalTo: document.bottomAnchor)
        } else {
            if (bottom?.secondItem as? Document)?.parent === document {
                align(document)
            }
        }
        documentView!.subviews.compactMap({ $0 as? Document }).filter({ $0.parent === document }).forEach {
            collapse($0)
            $0.removeFromSuperview()
        }
    }
    
    @objc func open(_ item: Document) {
        guard item !== selected else { return }
        selected = item
        Display.shared.open(item.document)
    }
    
    @objc func toggle() {
        Menu.shared.sidebar.state = Bar.shared.sidebar.state == .on ? .on : .off
        width.constant = Bar.shared.sidebar.state == .on ? open : 0
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
                App.shared.user.access = Access(panel.url!)
                App.shared.clear()
            }
        }
    }
    
    private func render(_ documents: [meta.Document],
                        origin: NSLayoutYAxisAnchor, margin: CGFloat, parent: Document?) -> Document? {
        return documents.reduce((nil, origin, margin)) {
            let document = Document($1, indent: parent == nil ? 0 : parent!.indent + 1)
            document.parent = parent
            documentView!.addSubview(document)
            
            document.widthAnchor.constraint(equalToConstant: open + 10).isActive = true
            document.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            document.top = document.topAnchor.constraint(equalTo: $0.1, constant: $0.2)
            return (document, document.bottomAnchor, 0)
        }.0
    }
    
    private func align(_ bottom: NSView) {
        self.bottom = documentView!.bottomAnchor.constraint(greaterThanOrEqualTo: bottom.bottomAnchor, constant: 20)
    }
}

private class Flipped: NSView { override var isFlipped: Bool { return true } }
