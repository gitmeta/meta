import meta
import AppKit

class Git: NSView {
    static let shared = Git()
    private weak var height: NSLayoutConstraint!
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
        
        let set = button("Set", target: self, action: #selector(self.status))
        let status = button("status", target: self, action: #selector(self.status))
        let commit = button("commit", target: self, action: #selector(self.commit))
        let reset = button("reset", target: self, action: #selector(self.reset))
        let pull = button("pull", target: self, action: #selector(self.pull))
        let push = button("push", target: self, action: #selector(self.push))
        
        height = heightAnchor.constraint(equalToConstant: open)
        height.isActive = true
        
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: open).isActive = true
        
        var right = leftAnchor
        [icon, set, status, commit, reset, pull, push].forEach {
            $0.leftAnchor.constraint(equalTo: right, constant: 4).isActive = true
            right = $0.rightAnchor
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc func toggle() {
        Menu.shared.git.state = Bar.shared.git.state == .on ? .on : .off
        height.constant = Bar.shared.git.state == .on ? open : 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    private func button(_ text: String, target: AnyObject, action: Selector) -> Link {
        return {
            $0.width.constant = 68
            $0.height.constant = 22
            $0.layer!.cornerRadius = 2
            addSubview($0)
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            return $0
        } (Link(text, background: .shade, text: .halo, font: .systemFont(ofSize: 12, weight: .medium), target: target, action: action))
    }
    
    @objc private func status() { Console.shared.log(git.status(App.shared.user)) }
    @objc private func commit() { Console.shared.log(git.commit(App.shared.user)) }
    @objc private func reset() { Console.shared.log(git.reset(App.shared.user)) }
    @objc private func pull() { Console.shared.log(git.pull(App.shared.user)) }
    @objc private func push() { Console.shared.log(git.push(App.shared.user)) }
}
