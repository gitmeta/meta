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
        label.font = .light(14)
        label.text = document.name
        addSubview(label)
        self.label = label
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if List.shared.selected === self {
            backgroundColor = .halo
            label.textColor = .black
        } else {
            backgroundColor = .shade
            label.textColor = .white
        }
    }
}
