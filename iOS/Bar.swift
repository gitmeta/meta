import UIKit

class Bar: UIView {
    static let shared = Bar()
    private var closed: NSLayoutConstraint! { didSet { closed.isActive = true } }
    private var opened: NSLayoutConstraint!
    private weak var title: UILabel!
    private weak var list: UIButton!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView(image: #imageLiteral(resourceName: "welcome.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        addSubview(image)
        
        let create = UIButton()
        create.translatesAutoresizingMaskIntoConstraints = false
        create.addTarget(List.shared, action: #selector(List.shared.create), for: .touchUpInside)
        create.setImage(#imageLiteral(resourceName: "new.pdf"), for: [])
        create.imageView!.clipsToBounds = true
        create.imageView!.contentMode = .center
        addSubview(create)
        
        let title = UILabel()
        title.alpha = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .bold(15)
        title.textColor = UIColor(white: 1, alpha: 0.5)
        addSubview(title)
        self.title = title
        
        let list = UIButton()
        list.alpha = 0
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setImage(#imageLiteral(resourceName: "listOn.pdf"), for: [])
        list.imageView!.clipsToBounds = true
        list.imageView!.contentMode = .center
        list.addTarget(List.shared, action: #selector(List.shared.show), for: .touchUpInside)
        addSubview(list)
        self.list = list
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closed = image.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        opened = image.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
        
        create.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        create.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15).isActive = true
        create.widthAnchor.constraint(equalToConstant: 60).isActive = true
        create.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        list.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        title.leftAnchor.constraint(equalTo: list.rightAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func open(_ title: String) {
        closed.isActive = false
        opened.isActive = true
        self.title.text = title
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 1
            self.list.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func close() {
        opened.isActive = false
        closed.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 0
            self.list.alpha = 0
            self.layoutIfNeeded()
        }
    }
}
