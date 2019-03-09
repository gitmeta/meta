import AppKit

class Bar: NSView {
    static let shared = Bar()
    private(set) weak var toggle: Button!
    private(set) weak var new: Button!
    private(set) weak var close: Button!
    private(set) weak var delete: Button!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let up = Button("up", target: List.shared, action: #selector(List.shared.select))
        up.keyEquivalent = "o"
        up.keyEquivalentModifierMask = .command
        
        let toggle = Button("listOff", type: .toggle, target: List.shared, action: #selector(List.shared.toggle))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        toggle.keyEquivalent = "l"
        toggle.keyEquivalentModifierMask = .command
        self.toggle = toggle
        
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
        
        [up, toggle, new, close, delete].forEach {
            addSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        widthAnchor.constraint(equalToConstant: 70).isActive = true
        up.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        toggle.topAnchor.constraint(equalTo: up.bottomAnchor, constant: 5).isActive = true
        new.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 5).isActive = true
        close.topAnchor.constraint(equalTo: new.bottomAnchor, constant: 5).isActive = true
        delete.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
