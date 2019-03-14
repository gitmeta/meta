import meta
import Shell
import AppKit

class Git: NSView {
    static let shared = Git()
    private weak var height: NSLayoutConstraint!
    private weak var statusLink: Link!
    private weak var commitLink: Link!
    private weak var resetLink: Link!
    private weak var pullLink: Link!
    private weak var pushLink: Link!
    private var shell: Service?
    private let open = CGFloat(50)
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let icon = NSImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = NSImage(named: "git")
        icon.imageScaling = .scaleNone
        addSubview(icon)
        
        statusLink = link("status", target: self, action: #selector(self.status))
        commitLink = link("commit", target: self, action: #selector(self.commit))
        resetLink = link("reset", target: self, action: #selector(self.reset))
        pullLink = link("pull", target: self, action: #selector(self.pull))
        pushLink = link("push", target: self, action: #selector(self.push))
        
        height = heightAnchor.constraint(equalToConstant: open)
        height.isActive = true
        
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: open).isActive = true
        
        var right = leftAnchor
        [icon, statusLink!, commitLink!, resetLink!, pullLink!, pushLink!].forEach {
            $0.leftAnchor.constraint(equalTo: right, constant: 4).isActive = true
            right = $0.rightAnchor
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if let access = App.shared.user.access {
            let service = NSXPCConnection(serviceName: "meta.Shell")
            service.remoteObjectInterface = NSXPCInterface(with: Service.self)
            service.resume()
            
            let data = try! access.url.bookmarkData()
            shell = service.remoteObjectProxyWithErrorHandler { Alert.shared.add($0) } as? Service
            shell!.activate(access.url, data: data)
        } else {
            shell = nil
        }
    }
    
    @objc func toggle() {
        Menu.shared.git.state = Bar.shared.git.state == .on ? .on : .off
        height.constant = Bar.shared.git.state == .on ? open : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    @objc func status() { shell?.status { Console.shared.log($0) } }
    @objc func commit() { shell?.commit { Console.shared.log($0) } }
    @objc func reset() { shell?.reset { Console.shared.log($0) } }
    @objc func pull() { shell?.pull { Console.shared.log($0) } }
    @objc func push() { shell?.push { Console.shared.log($0) } }
    
    private func link(_ text: String, target: AnyObject, action: Selector) -> Link {
        return {
            $0.width.constant = 64
            $0.height.constant = 22
            $0.layer!.cornerRadius = 2
            addSubview($0)
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            return $0
            } (Link(text, background: .shade, text: .halo, font: .systemFont(ofSize: 12, weight: .medium), target: target, action: action))
    }
}
