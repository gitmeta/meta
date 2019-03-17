import meta
import AppKit

class Welcome: Sheet {
    @discardableResult override init() {
        super.init()        
        let image = NSImageView()
        image.image = NSImage(named: "welcome")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let title = Label(.local("Welcome.title"), color: .white, font: .systemFont(ofSize: 20, weight: .bold))
        addSubview(title)
        
        let info = Label(.local("Welcome.infoDirectory"), color: .white, font: .systemFont(ofSize: 16, weight: .ultraLight))
        addSubview(info)
        
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
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40).isActive = true
        title.leftAnchor.constraint(equalTo: info.leftAnchor).isActive = true
        
        info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        open.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 40).isActive = true
        open.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        open.width.constant = 220
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: open.bottomAnchor, constant: 10).isActive = true
        
        check.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        check.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        show.centerYAnchor.constraint(equalTo: check.centerYAnchor).isActive = true
        show.leftAnchor.constraint(equalTo: check.rightAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func open() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin {
            if $0 == .OK {
                App.shared.user.access = Access(panel.url!, data: (try! panel.url!.bookmarkData(options: .withSecurityScope)))
                App.shared.clear()
                self.close()
                Alert.shared.add(.local("Welcome.ready"))
                Console.shared.log(.local("Welcome.update") + panel.url!.lastPathComponent)
            }
        }
    }
    
    @objc private func check(_ button: Button) {
        App.shared.user.welcome = button.state == .on
    }
}
