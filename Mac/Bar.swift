import AppKit

class Bar: NSView {
    static let shared = Bar()
    private(set) weak var sidebar: Button!
    private(set) weak var git: Button!
    private(set) weak var console: Button!
    private(set) weak var new: Button!
    private(set) weak var close: Button!
    private(set) weak var delete: Button!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let up = Button("up", target: List.shared, action: #selector(List.shared.select))
        up.keyEquivalent = "o"
        up.keyEquivalentModifierMask = .command
        
        let sidebar = Button("listOff", type: .toggle, target: List.shared, action: #selector(List.shared.toggle))
        sidebar.state = .on
        sidebar.alternateImage = NSImage(named: "listOn")
        sidebar.keyEquivalent = "l"
        sidebar.keyEquivalentModifierMask = .command
        self.sidebar = sidebar
        
        let git = Button("gitOff", type: .toggle, target: Git.shared, action: #selector(Git.shared.toggle))
        git.state = .on
        git.alternateImage = NSImage(named: "gitOn")
        git.keyEquivalent = "g"
        git.keyEquivalentModifierMask = [.option, .command]
        self.git = git
        
        let console = Button("consoleOff", type: .toggle, target: Console.shared, action: #selector(Console.shared.toggle))
        console.state = .on
        console.alternateImage = NSImage(named: "consoleOn")
        console.keyEquivalent = "c"
        console.keyEquivalentModifierMask = [.option, .command]
        self.console = console
        
        let new = Button("new", target: App.shared, action: #selector(App.shared.create))
        new.keyEquivalent = "n"
        new.keyEquivalentModifierMask = .command
        self.new = new
        
        let close = Button("close", target: App.shared, action: #selector(App.shared.shut))
        close.keyEquivalent = "w"
        close.keyEquivalentModifierMask = .command
        self.close = close
        
        let delete = Button("trash", target: App.shared, action: #selector(App.shared.delete))
        delete.keyEquivalent = "d"
        delete.keyEquivalentModifierMask = .command
        self.delete = delete
        
        [up, sidebar, git, console, new, close, delete].forEach {
            addSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        widthAnchor.constraint(equalToConstant: 70).isActive = true
        up.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        sidebar.topAnchor.constraint(equalTo: up.bottomAnchor, constant: 5).isActive = true
        git.topAnchor.constraint(equalTo: sidebar.bottomAnchor, constant: 5).isActive = true
        console.topAnchor.constraint(equalTo: git.bottomAnchor, constant: 5).isActive = true
        new.topAnchor.constraint(equalTo: console.bottomAnchor, constant: 5).isActive = true
        close.topAnchor.constraint(equalTo: new.bottomAnchor, constant: 5).isActive = true
        delete.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
