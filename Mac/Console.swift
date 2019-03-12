import AppKit

class Console: NSView {
    static let shared = Console()
    private weak var height: NSLayoutConstraint!
    private weak var text: NSTextView!
    private let open = CGFloat(200)
    private let format = DateFormatter()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.drawsBackground = false
        scroll.documentView = {
            $0.drawsBackground = false
            $0.isRichText = false
            $0.textContainerInset = NSSize(width: 10, height: 10)
            $0.isVerticallyResizable = true
            $0.isHorizontallyResizable = true
            $0.isEditable = false
            $0.textContainer!.lineBreakMode = .byCharWrapping
            text = $0
            return $0
        } (NSTextView())
        scroll.horizontalScrollElasticity = .none
        addSubview(scroll)
        
        let clear = Link(.local("Console.clear"), background: NSColor(white: 0.2, alpha: 0.8), text: NSColor(white: 1, alpha: 0.7),
                         font: .light(11), target: self, action: #selector(self.clear))
        addSubview(clear)
        
        scroll.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        scroll.heightAnchor.constraint(equalToConstant: open - 4).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        clear.width.constant = 60
        clear.height.constant = 24
        clear.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        clear.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        height = heightAnchor.constraint(equalToConstant: open)
        height.isActive = true
        
        format.dateStyle = .none
        format.timeStyle = .medium
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        text.frame = CGRect(x: 0, y: 0, width: bounds.width, height: text.frame.height)
    }
    
    func log(_ message: String) {
        DispatchQueue.main.async {
            self.text.textStorage!.append({
                $0.append(NSAttributedString(string: self.format.string(from: Date()) + " ", attributes: [
                    .font: NSFont.light(12), .foregroundColor: NSColor(white: 1, alpha: 0.5)]))
                $0.append(NSAttributedString(string: message + "\n", attributes: [
                    .font: NSFont.light(12), .foregroundColor: NSColor(white: 1, alpha: 0.75)]))
                return $0
            } (NSMutableAttributedString()))
            DispatchQueue.main.async {
                self.scroll()
            }
        }
        
    }
    
    private func scroll() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            text.scrollRangeToVisible(NSMakeRange(text.textStorage!.length, 0))
        }) { }
    }
    
    @objc func toggle() {
        Menu.shared.console.state = Bar.shared.console.state == .on ? .on : .off
        height.constant = Bar.shared.console.state == .on ? open : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    @objc private func clear() { text.string = String() }
}
