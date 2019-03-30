import UIKit

class Clone: Sheet, UITextFieldDelegate {
    private weak var url: UITextField!
    
    @discardableResult init() {
        super.init(true)
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .black
        base.layer.cornerRadius = 4
        addSubview(base)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.textColor = UIColor(white: 1, alpha: 0.35)
        title.text = .local("Clone.title")
        base.addSubview(title)
        
        let url = UITextField()
        url.translatesAutoresizingMaskIntoConstraints = false
        url.clearButtonMode = .never
        url.keyboardType = .URL
        url.keyboardAppearance = .dark
        url.spellCheckingType = .no
        url.autocorrectionType = .no
        url.autocapitalizationType = .none
        url.font = .systemFont(ofSize: 16, weight: .light)
        url.textColor = .white
        url.tintColor = .white
        url.delegate = self
        base.addSubview(url)
        self.url = url
        
        let image = UIImageView(image: #imageLiteral(resourceName: "clone.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let clone = Link(.local("Clone.continue"), target: self, selector: #selector(self.clone))
        addSubview(clone)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        cancel.setTitle(.local("Clone.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 14, weight: .light)
        addSubview(cancel)
        
        base.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -50).isActive = true
        base.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        base.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        base.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        title.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 14).isActive = true
        
        url.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 10).isActive = true
        url.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -4).isActive = true
        url.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        url.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 157).isActive = true
        image.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        clone.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        clone.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20).isActive = true
        clone.width.constant = 200
        
        cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(20 + App.shared.margin.bottom)).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: clone.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ready = { [weak self] in self?.url.becomeFirstResponder() }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        url.resignFirstResponder()
        return true
    }
    
    @objc private func cancel() {
        close()
        Welcome(false)
    }
    
    @objc private func clone() {
        url.resignFirstResponder()
        Git.shared.log(.local("Clone.log") + url.text!)
        let spinner = Spinner()
        Git.shared.git.clone(url.text!, path: App.shared.user.access!.url) { [weak self] in
            switch $0 {
            case .failure(let error):
                Alert.shared.add(error)
            case .success():
                List.shared.update()
                self?.close()
            }
            spinner.close()
        }
    }
}
