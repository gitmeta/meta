import meta
import AppKit

class Git: NSView {
    static let shared = Git()
    private let git = meta.Git()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let status = button("status", target: self, action: #selector(self.status))
        let commit = button("commit", target: self, action: #selector(self.commit))
        let reset = button("reset", target: self, action: #selector(self.reset))
        let pull = button("pull", target: self, action: #selector(self.pull))
        let push = button("push", target: self, action: #selector(self.push))
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        status.rightAnchor.constraint(equalTo: commit.leftAnchor, constant: -12).isActive = true
        commit.rightAnchor.constraint(equalTo: reset.leftAnchor, constant: -12).isActive = true
        reset.rightAnchor.constraint(equalTo: pull.leftAnchor, constant: -12).isActive = true
        pull.rightAnchor.constraint(equalTo: push.leftAnchor, constant: -12).isActive = true
        push.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func button(_ text: String, target: AnyObject, action: Selector) -> Link {
        return {
            $0.width.constant = 58
            $0.height.constant = 20
            $0.layer!.cornerRadius = 2
            addSubview($0)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
            return $0
        } (Link(text, background: .shade, text: .halo, font: .systemFont(ofSize: 11, weight: .medium), target: target, action: action))
    }
    
    @objc private func status() { Console.shared.log(git.status(App.shared.user)) }
    @objc private func commit() { Console.shared.log(git.commit(App.shared.user)) }
    @objc private func reset() { Console.shared.log(git.reset(App.shared.user)) }
    @objc private func pull() { Console.shared.log(git.pull(App.shared.user)) }
    @objc private func push() { Console.shared.log(git.push(App.shared.user)) }
}
