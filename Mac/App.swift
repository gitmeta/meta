import AppKit
import TCR

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
        
        contentView!.addSubview(Scroll.shared)
        contentView!.addSubview(Side.shared)
        contentView!.addSubview(Bar.shared)
        
        Side.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Side.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Side.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        Bar.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Bar.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Bar.shared.leftAnchor.constraint(equalTo: Side.shared.rightAnchor).isActive = true
        
        Scroll.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Scroll.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Scroll.shared.leftAnchor.constraint(equalTo: Bar.shared.rightAnchor).isActive = true
        Scroll.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            DispatchQueue.main.async {
                Side.shared.update()
            }
        }
    }
}
