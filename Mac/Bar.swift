import AppKit

class Bar: NSView {
    static let shared = Bar()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let up = Button("up", target: Side.shared, action: #selector(Side.shared.select))
        up.keyEquivalent = "o"
        up.keyEquivalentModifierMask = .command
        addSubview(up)
        
        let toggle = Button("listOff", type: .toggle, target: Side.shared, action: #selector(Side.shared.toggle(_:)))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        toggle.keyEquivalent = "l"
        toggle.keyEquivalentModifierMask = .command
        addSubview(toggle)
        
        widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        up.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        up.heightAnchor.constraint(equalToConstant: 30).isActive = true
        up.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        up.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        toggle.topAnchor.constraint(equalTo: up.bottomAnchor, constant: 5).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        toggle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        toggle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
