import meta
import UIKit

class Document: UIControl {
    let document: meta.Document
    private weak var label: UILabel!
    
    init(_ document: meta.Document) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 6
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        addSubview(label)
        self.label = label
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if List.shared.selected === self {
            layer.backgroundColor = UIColor.shade.cgColor
            label.alpha = 0.9
        } else {
            layer.backgroundColor = nil
            label.alpha = 0.6
        }
    }
}
