import UIKit

class Bar: UIView {
    static let shared = Bar()
    private(set) weak var title: UILabel!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .bold(15)
        title.textColor = UIColor(white: 1, alpha: 0.5)
        addSubview(title)
        self.title = title
        
        let list = UIButton()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setImage(#imageLiteral(resourceName: "listOn.pdf"), for: [])
        list.imageView!.clipsToBounds = true
        list.imageView!.contentMode = .center
        list.addTarget(List.shared, action: #selector(List.shared.show), for: .touchUpInside)
        addSubview(list)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        list.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        title.leftAnchor.constraint(equalTo: list.rightAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
