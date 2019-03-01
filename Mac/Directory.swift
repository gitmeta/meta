import AppKit
import TCR

class Directory: NSView {
    private weak var document: TCR.Directory?
    
    init(_ document: TCR.Directory) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.document = document
        
        let label = Label(document.name, color: NSColor(white: 1, alpha: 0.5), font:
            .systemFont(ofSize: 30, weight: .bold), align: .center)
        addSubview(label)
        
        let button = Button("down", target: self, action: #selector(down))
        button.keyEquivalent = "\r"
        addSubview(button)
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func down() {
        guard
            let name = document?.name,
            let url = App.shared.user.bookmark.first?.key.appendingPathComponent(name),
            let data = App.shared.user.bookmark.first?.value
        else { return }
        App.shared.user.bookmark = [url: data]
        Scroll.shared.clear()
        Side.shared.update()
    }
}
