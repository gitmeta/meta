import UIKit

class Reset: Sheet {
    @discardableResult init() {
        super.init(true)
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .black
        base.layer.cornerRadius = 4
        addSubview(base)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.text = .local("Reset.title")
        title.textColor = .white
        addSubview(title)
        
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.font = .systemFont(ofSize: 14, weight: .ultraLight)
        info.text = .local("Reset.info")
        info.textColor = .white
        addSubview(info)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "delete.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let reset = Link(.local("Reset.continue"), target: self, selector: #selector(self.reset))
        addSubview(reset)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        cancel.setTitle(.local("Reset.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 14, weight: .light)
        addSubview(cancel)
        
        title.bottomAnchor.constraint(equalTo: info.topAnchor, constant: -10).isActive = true
        title.leftAnchor.constraint(equalTo: info.leftAnchor).isActive = true
        
        info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        info.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -40).isActive = true
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        reset.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        reset.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20).isActive = true
        reset.width.constant = 200
        
        cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(20 + App.shared.margin.bottom)).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: reset.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func reset() {
        let spinner = Spinner()
        spinner.ready = {
            Git.shared.git.reset { [weak self] in
                spinner.close()
                switch $0 {
                case .failure(let error): Alert.shared.add(error)
                case .success():
                    Git.shared.log(.local("Git.reseted"))
                    List.shared.update()
                }
                self?.close()
            }
        }
    }
}
