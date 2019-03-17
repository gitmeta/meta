import meta
import AppKit
import StoreKit

@NSApplicationMain class App: NSWindow, NSApplicationDelegate {
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
        Git.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        Git.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        Console.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Console.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        Console.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        Bar.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Bar.shared.bottomAnchor.constraint(equalTo: Git.shared.topAnchor).isActive = true
        Bar.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        
        Display.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Display.shared.bottomAnchor.constraint(equalTo: Git.shared.topAnchor).isActive = true
        Display.shared.leftAnchor.constraint(equalTo: Bar.shared.rightAnchor).isActive = true
        Display.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        state()
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            if let access = self.user.access {
                var stale = false
                _ = (try? URL(resolvingBookmarkData: access.data, options: .withSecurityScope, bookmarkDataIsStale:
                    &stale))?.startAccessingSecurityScopedResource()
                Console.shared.log(.local("Welcome.update") + access.url.lastPathComponent)
            }
            self.user.ask = { if #available(OSX 10.14, *) { SKStoreReviewController.requestReview() } }
            DispatchQueue.main.async {
                List.shared.update()
                if self.user.welcome { List.shared.select() }
            }
        }
    }
    
    func state() {
        Bar.shared.new.isEnabled = user?.access != nil
        Bar.shared.close.isEnabled = List.shared.selected != nil
        Bar.shared.delete.isEnabled = List.shared.selected != nil
        Menu.shared.fileNew.isEnabled = Bar.shared.new.isEnabled
        Menu.shared.fileClose.isEnabled = Bar.shared.close.isEnabled
        Menu.shared.fileDelete.isEnabled = Bar.shared.delete.isEnabled
    }
    
    func clear() {
        Display.shared.clear()
        List.shared.clear()
        List.shared.update()
        state()
    }
    
    @objc func shut() {
        Display.shared.clear()
        List.shared.selected = nil
        state()
    }
    
    @objc func delete() { Delete() }
    @objc func create() { Create() }
    @IBAction private func showHelp(_: Any?) { Help() }
}
