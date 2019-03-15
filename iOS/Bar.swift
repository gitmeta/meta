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
        
        let nose = UIButton()
        nose.translatesAutoresizingMaskIntoConstraints = false
        nose.setImage(#imageLiteral(resourceName: "nose.pdf"), for: [])
        nose.addTarget(self, action: #selector(help), for: .touchUpInside)
        nose.imageView!.clipsToBounds = true
        nose.imageView!.contentMode = .center
        addSubview(nose)
        
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
        title.textColor = .halo
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
        
        nose.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nose.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nose.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nose.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closed = nose.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        opened = nose.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        create.centerYAnchor.constraint(equalTo: nose.centerYAnchor).isActive = true
        create.leftAnchor.constraint(equalTo: nose.rightAnchor, constant: 5).isActive = true
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
    
    @objc private func help() {
        if !App.shared.creating {
            Help()
        }
    }
}
