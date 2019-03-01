import AppKit
import meta

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
        contentView!.addSubview(Bar.shared)
        
        List.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        List.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        List.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        Bar.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Bar.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Bar.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        
        Display.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Display.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Display.shared.leftAnchor.constraint(equalTo: Bar.shared.rightAnchor).isActive = true
        Display.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            DispatchQueue.main.async {
                List.shared.update()
            }
        }
    }
}
