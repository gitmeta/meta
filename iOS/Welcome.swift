import UIKit

class Welcome: Sheet {
    @discardableResult override init(_ animated: Bool = true) {
        super.init(animated)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "welcome.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let create = Link(.local("Welcome.create"), target: self, selector: #selector(self.create))
        addSubview(create)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle(.local("Welcome.close"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 15, weight: .medium)
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        addSubview(cancel)
        
        let check = UIButton()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.setImage(#imageLiteral(resourceName: "checkOff.pdf"), for: .normal)
        check.setImage(#imageLiteral(resourceName: "checkOn.pdf"), for: .selected)
        check.imageView!.clipsToBounds = true
        check.imageView!.contentMode = .center
        check.addTarget(self, action: #selector(check(_:)), for: .touchUpInside)
        check.isSelected = App.shared.user.welcome
        addSubview(check)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = .local("Welcome.show")
        label.textColor = UIColor(white: 1, alpha: 0.7)
        addSubview(label)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.text = .local("Welcome.title")
        title.textColor = .white
        addSubview(title)
        
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.font = .systemFont(ofSize: 16, weight: .ultraLight)
        info.text = .local("Welcome.infoFile")
        info.textColor = .white
        addSubview(info)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        title.leftAnchor.constraint(equalTo: info.leftAnchor).isActive = true
        
        info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        create.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 40).isActive = true
        create.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        create.width.constant = 200
        
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: create.bottomAnchor, constant: 10).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        check.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        check.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        check.widthAnchor.constraint(equalToConstant: 56).isActive = true
        check.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        label.centerYAnchor.constraint(equalTo: check.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: check.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func create() {
        close()
        List.shared.create()
    }
    
    @objc private func check(_ button: UIButton) {
        button.isSelected.toggle()
        App.shared.user.welcome = button.isSelected
    }
}
