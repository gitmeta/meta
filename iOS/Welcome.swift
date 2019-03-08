import UIKit

class Welcome: Sheet {
    @discardableResult override init() {
        super.init()
        
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
        
        image.rightAnchor.constraint(equalTo: centerXAnchor, constant: -20).isActive = true
        image.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        create.topAnchor.constraint(equalTo: image.topAnchor, constant: 15).isActive = true
        create.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 20).isActive = true
        
        cancel.leftAnchor.constraint(equalTo: create.leftAnchor).isActive = true
        cancel.rightAnchor.constraint(equalTo: create.rightAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: create.bottomAnchor, constant: 15).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        check.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        check.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
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
