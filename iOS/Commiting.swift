import UIKit

class Commiting: UIControl {
    private(set) weak var label: UILabel!
    private weak var image: UIImageView!
    
    init(_ name: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.font = .light(14)
        label.textColor = .white
        addSubview(label)
        self.label = label
        
        let image = UIImageView(image: #imageLiteral(resourceName: "check.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = false
        addSubview(image)
        self.image = image
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        toggle()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override var isSelected: Bool { didSet { image.isHidden = !isSelected } }
    
    @objc private func toggle() {
        isSelected.toggle()
    }
}
