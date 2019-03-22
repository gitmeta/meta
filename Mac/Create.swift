import AppKit

class Create: Sheet, NSTextFieldDelegate {
    private weak var name: NSTextField!
    
    @discardableResult override init() {
        super.init()
        let title = Label(.local("Create.title"), color: .white, font: .systemFont(ofSize: 20, weight: .bold))
        addSubview(title)
        
        let image = NSImageView()
        image.image = NSImage(named: "nose")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isBezeled = false
        name.font = .light(20)
        name.focusRingType = .none
        name.drawsBackground = false
        name.textColor = .white
        name.maximumNumberOfLines = 1
        name.lineBreakMode = .byTruncatingHead
        name.delegate = self
        addSubview(name)
        (name.window?.fieldEditor(true, for: name) as! NSTextView).insertionPointColor = .halo
        self.name = name
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.white.cgColor
        addSubview(border)
        
        let create = Link(.local("Create.confirm"), background: .halo, text: .black,
                          target: self, action: #selector(self.create))
        create.keyEquivalent = "\r"
        addSubview(create)
        
        let cancel = Link(.local("Create.cancel"), text: NSColor(white: 1, alpha: 0.6),
                          font: .systemFont(ofSize: 16, weight: .light), target: self, action: #selector(close))
        addSubview(cancel)
        
        title.bottomAnchor.constraint(equalTo: name.topAnchor, constant: -50).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        image.rightAnchor.constraint(equalTo: title.leftAnchor, constant: -30).isActive = true
        image.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 210).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        border.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: name.leftAnchor, constant: -5).isActive = true
        border.rightAnchor.constraint(equalTo: name.rightAnchor, constant: 5).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        create.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        create.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: create.bottomAnchor, constant: 5).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak name] in
            App.shared.makeFirstResponder(name)
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        if (doCommandBy == #selector(NSResponder.insertNewline(_:))) {
            create()
            return true
        }
        return false
    }
    
    @objc private func create() {
        App.shared.makeFirstResponder(nil)
        guard !name.stringValue.isEmpty else { return close() }
        do {
            try List.shared.folder.createFile(name.stringValue, user: App.shared.user)
            App.shared.clear()
            close()
        } catch { Alert.shared.add(error) }
    }
}
