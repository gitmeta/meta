import meta
import AppKit

class Activate: Sheet {
    @discardableResult override init() {
        super.init()
        
        let nose = NSImageView()
        nose.translatesAutoresizingMaskIntoConstraints = false
        nose.image = NSImage(named: "nose")
        nose.imageScaling = .scaleNone
        addSubview(nose)
        
        let git = NSImageView()
        git.translatesAutoresizingMaskIntoConstraints = false
        git.image = NSImage(named: "git")
        git.imageScaling = .scaleNone
        addSubview(git)
        
        let title = Label(.local("Activate.title"), color: .white, font: .systemFont(ofSize: 20, weight: .bold))
        addSubview(title)
        
        let info = Label(.local("Activate.info"), color: .white, font: .systemFont(ofSize: 16, weight: .ultraLight))
        addSubview(info)
        
        let open = Link(.local("Activate.select"), background: .halo, text: .black, target: self, action: #selector(self.open))
        open.keyEquivalent = "\r"
        addSubview(open)
        
        let cancel = Link(.local("Activate.cancel"), text: NSColor(white: 1, alpha: 0.6),
                          font: .systemFont(ofSize: 16, weight: .light), target: self, action: #selector(close))
        addSubview(cancel)
        
        nose.rightAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        nose.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        
        git.centerYAnchor.constraint(equalTo: nose.centerYAnchor).isActive = true
        git.leftAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        
        title.topAnchor.constraint(equalTo: nose.bottomAnchor, constant: 40).isActive = true
        title.leftAnchor.constraint(equalTo: info.leftAnchor).isActive = true
        
        info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        open.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 40).isActive = true
        open.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        open.width.constant = 220
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: open.bottomAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func open() {
        let panel = NSOpenPanel()
        panel.directoryURL = URL(fileURLWithPath: NSHomeDirectory())
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.begin {
            if $0 == .OK {
                do {
                    try App.shared.user.update(panel.url!)
                    App.shared.state()
                    Alert.shared.add(.local("Activate.ready"))
                    self.close()
                } catch {
                    Alert.shared.add(error)
                }
            }
        }
    }
}
