import AppKit

class Delete: Sheet {
    @discardableResult override init() {
        super.init()
        let title = Label(List.shared.selected!.document.name, color: .white, font: .systemFont(ofSize: 16, weight: .bold))
        addSubview(title)
        
        let image = NSImageView()
        image.image = NSImage(named: "delete")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let delete = Link(.local("Document.deleteConfirm"), background: .black, text: .white,
                          target: self, action: #selector(self.delete))
        delete.keyEquivalent = "\r"
        addSubview(delete)
        
        let cancel = Link(.local("Document.deleteCancel"), text: NSColor(white: 1, alpha: 0.6),
                          font: .systemFont(ofSize: 16, weight: .light), target: self, action: #selector(close))
        addSubview(cancel)
        
        title.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -20).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        delete.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        delete.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: delete.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func delete() {
        do {
            try List.shared.folder.delete(List.shared.selected!.document)
            App.shared.clear()
        } catch { Alert.shared.add(error) }
        close()
    }
}
