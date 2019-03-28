import meta
import UIKit

class Historying: UIView {
    init(_ item: meta.Commit) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = {
            $0.append(NSAttributedString(string: item.author + "\n", attributes: [.font: UIFont.light(14),
                                                                                  .foregroundColor: UIColor(white: 1, alpha: 0.6)]))
            $0.append(NSAttributedString(string: item.message, attributes: [.font: UIFont.light(14), .foregroundColor: UIColor.white]))
            return $0
        } (NSMutableAttributedString())
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
