import AppKit

class Menu: NSMenu {
    static private(set) weak var shared: Menu!
    @IBOutlet private(set) weak var sidebar: NSMenuItem!
    @IBOutlet private weak var fileNew: NSMenuItem!
    @IBOutlet private weak var fileOpen: NSMenuItem!
    @IBOutlet private(set) weak var fileClose: NSMenuItem!
    @IBOutlet private weak var fileDelete: NSMenuItem!
    @IBOutlet private weak var windowWelcome: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Menu.shared = self
        sidebar.target = self
        sidebar.action = #selector(toggle)
        
        fileOpen.target = List.shared
        fileOpen.action = #selector(List.shared.select)
        
        fileClose.target = App.shared
        fileClose.action = #selector(App.shared.shut)
        
        windowWelcome.target = self
        windowWelcome.action = #selector(welcome)
    }
    
    @objc func welcome() {
        guard App.shared.presenting == nil else { return }
        Welcome()
    }
    
    @objc private func toggle() {
        Bar.shared.toggle.state = Bar.shared.toggle.state == .on ? .off : .on
        List.shared.toggle()
    }
}
