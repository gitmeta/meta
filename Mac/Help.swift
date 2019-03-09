import AppKit

class Help: Sheet {
    @discardableResult override init() {
        super.init()
        let title = Label(.local("Help.title"), font: .bold(20))
        addSubview(title)
        
        let image = NSImageView()
        image.image = NSImage(named: "help")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let write = Link(.local("Help.write"), background: .halo, text: .black, target: self, action: #selector(self.write))
        write.keyEquivalent = "\r"
        addSubview(write)
        
        let cancel = Link(.local("Help.cancel"), text: NSColor(white: 1, alpha: 0.6),
                          font: .systemFont(ofSize: 16, weight: .light), target: self, action: #selector(close))
        addSubview(cancel)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -65).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        title.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -30).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        write.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -10).isActive = true
        write.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: write.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: write.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func write() {
        let service = NSSharingService(named: .composeEmail)
        service?.recipients = ["meta@iturbi.de"]
        service?.subject = .local("Help.subject")
        if service?.canPerform(withItems: nil) == true {
            service?.perform(withItems: [])
        }
        close()
    }
}
