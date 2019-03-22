import meta
import UIKit

class Image: UIView {
    init(_ document: meta.Image) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(data: try! Data(contentsOf: document.url))
        image.contentMode = .scaleAspectFit
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        image.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(image)
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
