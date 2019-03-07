import meta
import AppKit

class Directory: NSView {
    init(_ document: meta.Directory) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = Label(document.name, color: NSColor(white: 1, alpha: 0.5), font:
            .systemFont(ofSize: 30, weight: .bold), align: .center)
        addSubview(label)
        
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
