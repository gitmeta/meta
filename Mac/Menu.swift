import AppKit

class Menu: NSMenu {
    static private(set) weak var shared: Menu!
    @IBOutlet private(set) weak var sidebar: NSMenuItem!
    @IBOutlet private weak var fileNew: NSMenuItem!
    @IBOutlet private weak var fileOpen: NSMenuItem!
    @IBOutlet private weak var fileClose: NSMenuItem!
    @IBOutlet private weak var fileDelete: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Menu.shared = self
        sidebar.target = self
        sidebar.action = #selector(toggle)
    }
    
    @objc private func toggle() {
        Bar.shared.toggle.state = Bar.shared.toggle.state == .on ? .off : .on
        List.shared.toggle()
    }
}
