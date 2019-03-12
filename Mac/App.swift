import meta
import AppKit
import StoreKit

@NSApplicationMain class App: NSWindow, NSApplicationDelegate {
    enum State {
        case none
        case welcomed
        case folder
        case document
    }
    
    static private(set) weak var shared: App!
    private(set) var user: User!
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { return true }
    override func cancelOperation(_: Any?) { makeFirstResponder(nil) }
    override func mouseDown(with: NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")
        backgroundColor = .black
        NSApp.delegate = self
        App.shared = self
        
        contentView!.addSubview(Display.shared)
        contentView!.addSubview(List.shared)
        contentView!.addSubview(Git.shared)
        contentView!.addSubview(Console.shared)
        contentView!.addSubview(Bar.shared)
        
        List.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        List.shared.bottomAnchor.constraint(equalTo: Git.shared.topAnchor).isActive = true
        List.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        Git.shared.bottomAnchor.constraint(equalTo: Console.shared.topAnchor).isActive = true
        Git.shared.widthAnchor.constraint(equalTo: List.shared.widthAnchor).isActive = true
        Git.shared.rightAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        
        Console.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Console.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        Console.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        Bar.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Bar.shared.bottomAnchor.constraint(equalTo: Console.shared.topAnchor).isActive = true
        Bar.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        
        Display.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Display.shared.bottomAnchor.constraint(equalTo: Console.shared.topAnchor).isActive = true
        Display.shared.leftAnchor.constraint(equalTo: Bar.shared.rightAnchor).isActive = true
        Display.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        state = .welcomed
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            if let data = self.user.access?.data {
                var stale = false
                _ = (try! URL(resolvingBookmarkData: data, options: .withSecurityScope, bookmarkDataIsStale: &stale))
                    .startAccessingSecurityScopedResource()
            }
            self.user.ask = { if #available(OSX 10.14, *) { SKStoreReviewController.requestReview() } }
            DispatchQueue.main.async {
                List.shared.update()
                if self.user.welcome { Menu.shared.openWelcome() }
            }
        }
    }
    
    var state = State.none { didSet {
        switch state {
        case .none:
            Bar.shared.new.isEnabled = false
            Bar.shared.close.isEnabled = false
            Bar.shared.delete.isEnabled = false
            Menu.shared.fileNew.isEnabled = false
            Menu.shared.fileClose.isEnabled = false
            Menu.shared.fileDelete.isEnabled = false
        case .welcomed:
            Bar.shared.new.isEnabled = false
            Bar.shared.close.isEnabled = false
            Bar.shared.delete.isEnabled = false
            Menu.shared.fileNew.isEnabled = false
            Menu.shared.fileClose.isEnabled = false
            Menu.shared.fileDelete.isEnabled = false
        case .folder:
            Bar.shared.new.isEnabled = true
            Bar.shared.close.isEnabled = false
            Bar.shared.delete.isEnabled = false
            Menu.shared.fileNew.isEnabled = true
            Menu.shared.fileClose.isEnabled = false
            Menu.shared.fileDelete.isEnabled = false
        case .document:
            Bar.shared.new.isEnabled = true
            Bar.shared.close.isEnabled = true
            Bar.shared.delete.isEnabled = true
            Menu.shared.fileNew.isEnabled = true
            Menu.shared.fileClose.isEnabled = true
            Menu.shared.fileDelete.isEnabled = true
        }
    } }
    
    func clear() {
        state = .none
        Display.shared.clear()
        List.shared.clear()
        List.shared.update()
    }
    
    @objc func shut() {
        state = .folder
        Display.shared.clear()
        List.shared.selected = nil
    }
    
    @objc func delete() { Delete() }
    @objc func create() { Create() }
    @IBAction private func showHelp(_: Any?) { Help() }
}
