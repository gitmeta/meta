import meta
import AppKit

class Git: NSView {
    static let shared = Git()
    private weak var height: NSLayoutConstraint!
    private weak var statusLink: Link!
    private weak var commitLink: Link!
    private weak var resetLink: Link!
    private weak var pullLink: Link!
    private weak var pushLink: Link!
    private let git = meta.Git()
    private let open = CGFloat(50)
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let icon = NSImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = NSImage(named: "git")
        icon.imageScaling = .scaleNone
        addSubview(icon)
        
        let activate = link(.local("Git.activate"), target: self, action: #selector(self.activate))
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
        [icon, activate, statusLink!, commitLink!, resetLink!, pullLink!, pushLink!].forEach {
            $0.leftAnchor.constraint(equalTo: right, constant: 4).isActive = true
            right = $0.rightAnchor
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    var enabled: Bool {
        get { return false }
        set {
            [statusLink, commitLink, resetLink, pullLink, pushLink].forEach {
                $0.isEnabled = newValue
            }
            [Menu.shared.gitStatus, Menu.shared.gitCommit, Menu.shared.gitReset, Menu.shared.gitPush, Menu.shared.gitPull].forEach {
                $0.isEnabled = newValue
            }
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
    
    @objc func activate() { Activate() }
    
    @objc func status() {
        //DispatchQueue.global(qos: .background).async { Console.shared.log(self.git.status(App.shared.user)) }
        
        
        let connection = NSXPCConnection(serviceName: "meta.Shell")
        connection.remoteObjectInterface = NSXPCInterface(with: Shell.self)
        connection.resume()
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error:", error.localizedDescription)
            } as! Shell
        service.hello{
            print($0)
        }
        print("service \(service)")
    }
    
    @objc func commit() {
        DispatchQueue.global(qos: .background).async { Console.shared.log(self.git.commit(App.shared.user)) }
    }
    
    @objc func reset() {
        DispatchQueue.global(qos: .background).async { Console.shared.log(self.git.reset(App.shared.user)) }
    }
    
    @objc func pull() {
        DispatchQueue.global(qos: .background).async { Console.shared.log(self.git.pull(App.shared.user)) }
    }
    
    @objc func push() {
        DispatchQueue.global(qos: .background).async { Console.shared.log(self.git.push(App.shared.user)) }
    }
    
    private func link(_ text: String, target: AnyObject, action: Selector) -> Link {
        return {
            $0.width.constant = 70
            $0.height.constant = 22
            $0.layer!.cornerRadius = 2
            addSubview($0)
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            return $0
            } (Link(text, background: .shade, text: .halo, font: .systemFont(ofSize: 12, weight: .medium), target: target, action: action))
    }
}
