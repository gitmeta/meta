import meta
import AppKit

class Alert {
    static let shared = Alert()
    private weak var view: NSView?
    private weak var bottom: NSLayoutConstraint?
    private var alert = [String]()
    private let messages: [Exception?: String] = [
        Exception.fileAlreadyExists: .local("Alert.fileAlreadyExists"),
        Exception.folderNotFound: .local("Alert.folderNotFound"),
        Exception.fileNoExists: .local("Alert.fileNoExists"),
        Exception.invalidHome: .local("Alert.invalidHome"),
        Exception.unknown: .local("Alert.unknown")]
    
    private init() { }
    func add(_ error: Error) { add(messages[error as? Exception] ?? .local("Alert.unknown")) }
    
    func add(_ message: String) {
        alert.append(message)
        DispatchQueue.main.async { if self.view === nil { self.pop() } }
    }
    
    private func pop() {
        guard !alert.isEmpty else { return }
        let view = NSButton()
        view.target = self
        view.action = #selector(remove)
        view.isBordered = false
        view.title = String()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer!.backgroundColor = NSColor.halo.cgColor
        view.layer!.cornerRadius = 4
        view.alphaValue = 0
        App.shared.contentView!.addSubview(view)
        self.view = view
        
        let message = Label(alert.removeFirst(), color: .black, font: .systemFont(ofSize: 16, weight: .regular))
        view.addSubview(message)
        
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.leftAnchor.constraint(equalTo:App.shared.contentView!.leftAnchor, constant: 10).isActive = true
        view.rightAnchor.constraint(equalTo:App.shared.contentView!.rightAnchor, constant: -10).isActive = true
        bottom = view.bottomAnchor.constraint(equalTo: App.shared.contentView!.topAnchor)
        bottom!.isActive = true
        
        message.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        message.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        App.shared.contentView!.layoutSubtreeIfNeeded()
        bottom!.constant = 90
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            view.alphaValue = 1
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak view] in
                if view != nil && view === self.view {
                    self.remove()
                }
            }
        }
    }
    
    @objc private func remove() {
        bottom?.constant = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            view?.alphaValue = 0
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) {
            self.view?.removeFromSuperview()
            self.pop()
        }
    }
}
