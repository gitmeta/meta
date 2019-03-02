import AppKit

class Welcome: Sheet {
    @discardableResult override init() {
        super.init()
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.blendingMode = .behindWindow
        blur.material = .dark
        addSubview(blur)
        
        let image = NSImageView()
        image.image = NSImage(named: "welcome")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let open = Link(.local("Welcome.select"), background: .halo, text: .black, target: self, action: #selector(self.open))
        open.keyEquivalent = "\r"
        addSubview(open)
        
        let cancel = Link(.local("Welcome.close"), text: NSColor(white: 1, alpha: 0.6),
                          font: .systemFont(ofSize: 16, weight: .light), target: self, action: #selector(close))
        addSubview(cancel)
        
        let check = Button("checkOff", type: .toggle, target: self, action: #selector(check(_:)))
        check.state = App.shared.user.welcome ? .on : .off
        check.alternateImage = NSImage(named: "checkOn")
        addSubview(check)
        
        let show = Label(.local("Welcome.show"), color: NSColor(white: 1, alpha: 0.7),
                         font: .systemFont(ofSize: 14, weight: .light))
        addSubview(show)
        
        blur.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -65).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        open.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -10).isActive = true
        open.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: open.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: open.bottomAnchor, constant: 5).isActive = true
        
        check.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        check.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        show.centerYAnchor.constraint(equalTo: check.centerYAnchor).isActive = true
        show.leftAnchor.constraint(equalTo: check.rightAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func open() {
        List.shared.select()
        close()
    }
    
    @objc private func check(_ button: Button) {
        App.shared.user.welcome = button.state == .on
    }
}
