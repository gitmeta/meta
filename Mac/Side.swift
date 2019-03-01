import AppKit
import TCR

class Side: NSScrollView {
    static let shared = Side()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    let folder = Folder()
    private weak var width: NSLayoutConstraint!
    private weak var link: Link!
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
        
        width = widthAnchor.constraint(equalToConstant: open)
        width.isActive = true
        
        let link = Link(String(), background: .clear, target: self, action: #selector(select))
        link.alignment = .left
        documentView!.addSubview(link)
        self.link = link
        
        link.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        link.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        link.width.constant = open - 14
        link.height.constant = 42
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        documentView!.subviews.filter({ $0 is Document }).forEach({ $0.removeFromSuperview() })
        link.attributedTitle = NSAttributedString(string: App.shared.user.folder ?? .local("Side.select"), attributes:
            [.font: NSFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: NSColor(white: 1, alpha: 0.5)])
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
                self.documentView!.bottomAnchor.constraint(equalTo: top, constant: 20).isActive = true
            }
        }
    }
    
    @objc func open(_ item: Document) {
        guard item !== selected else { return }
        selected = item
        Scroll.shared.open(item.document)
    }
    
    @objc func toggle(_ button: Button) {
        width.constant = button.state == .on ? open : 0
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
        panel.message = .local("Side.open")
        panel.begin {
            if $0 == .OK {
                Scroll.shared.clear()
                App.shared.user.bookmark = [panel.url!: try! panel.url!.bookmarkData(options: .withSecurityScope)]
                self.update()
            }
        }
    }
}

private class Flipped: NSView { override var isFlipped: Bool { return true } }
