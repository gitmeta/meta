import UIKit

class Replace: Sheet {
    @discardableResult init() {
        super.init(true)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.textColor = .white
        title.text = .local("Replace.title")
        addSubview(title)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "replace.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.font = .systemFont(ofSize: 14, weight: .ultraLight)
        info.textColor = .white
        info.numberOfLines = 0
        info.textAlignment = .center
        info.text = .local("Replace.info")
        addSubview(info)
        
        let replace = Link(.local("Replace.continue"), target: self, selector: #selector(self.replace))
        addSubview(replace)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        cancel.setTitle(.local("Replace.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 14, weight: .light)
        addSubview(cancel)
        
        title.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -20).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        image.bottomAnchor.constraint(equalTo: info.topAnchor, constant: -20).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        info.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        info.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        replace.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        replace.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20).isActive = true
        replace.width.constant = 200
        
        cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(20 + App.shared.margin.bottom)).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: replace.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func cancel() {
        close()
        Welcome()
    }
    
    @objc private func replace() {
        let spinner = Spinner()
        DispatchQueue.global(qos: .background).async {
            List.shared.folder.clear(App.shared.user.access!.url)
            Git.shared.git.close()
            Git.shared.log(.local("Replace.log"))
            DispatchQueue.main.async { [weak self] in
                spinner.close()
                self?.close()
                Clone()
            }
        }
    }
}
