import AppKit

class Menu: NSMenu {
    static private(set) weak var shared: Menu!
    @IBOutlet private(set) weak var sidebar: NSMenuItem!
    @IBOutlet private(set) weak var git: NSMenuItem!
    @IBOutlet private(set) weak var console: NSMenuItem!
    @IBOutlet private(set) weak var fileNew: NSMenuItem!
    @IBOutlet private weak var fileOpen: NSMenuItem!
    @IBOutlet private(set) weak var fileClose: NSMenuItem!
    @IBOutlet private(set) weak var fileDelete: NSMenuItem!
    @IBOutlet private weak var welcome: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Menu.shared = self
        sidebar.target = self
        sidebar.action = #selector(toggleSidebar)
        
        git.target = self
        git.action = #selector(toggleGit)
        
        console.target = self
        console.action = #selector(toggleConsole)
        
        fileNew.target = App.shared
        fileNew.action = #selector(App.shared.create)
        
        fileOpen.target = List.shared
        fileOpen.action = #selector(List.shared.select)
        
        fileClose.target = App.shared
        fileClose.action = #selector(App.shared.shut)
        
        welcome.target = self
        welcome.action = #selector(openWelcome)
    }
    
    @objc func openWelcome() { Welcome() }
    
    @objc private func toggleSidebar() {
        Bar.shared.sidebar.state = Bar.shared.sidebar.state == .on ? .off : .on
        List.shared.toggle()
    }
    
    @objc private func toggleGit() {
        Bar.shared.git.state = Bar.shared.git.state == .on ? .off : .on
        Git.shared.toggle()
    }
    
    @objc private func toggleConsole() {
        Bar.shared.console.state = Bar.shared.console.state == .on ? .off : .on
        Console.shared.toggle()
    }
}
