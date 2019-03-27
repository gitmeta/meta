import meta
import UIKit

class Credentials: Sheet, UITextFieldDelegate {
    private var success: (() -> Void)!
    private weak var name: UITextField!
    private weak var email: UITextField!
    
    @discardableResult init(_ success: @escaping(() -> Void)) {
        self.success = success
        super.init(true)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "credentials.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .black
        base.layer.cornerRadius = 4
        addSubview(base)
        
        let done = Link(.local("Credentials.done"), target: self, selector: #selector(self.done))
        addSubview(done)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        cancel.setTitle(.local("Credentials.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 14, weight: .light)
        addSubview(cancel)
        
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.font = .systemFont(ofSize: 16, weight: .bold)
        titleName.textColor = UIColor(white: 1, alpha: 0.35)
        titleName.text = .local("Credentials.name")
        base.addSubview(titleName)
        
        let titleEmail = UILabel()
        titleEmail.translatesAutoresizingMaskIntoConstraints = false
        titleEmail.font = .systemFont(ofSize: 16, weight: .bold)
        titleEmail.textColor = UIColor(white: 1, alpha: 0.35)
        titleEmail.text = .local("Credentials.email")
        base.addSubview(titleEmail)
        
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = App.shared.user.credentials?.name
        name.clearButtonMode = .never
        name.keyboardType = .alphabet
        name.keyboardAppearance = .dark
        name.spellCheckingType = .no
        name.autocorrectionType = .no
        name.autocapitalizationType = .none
        name.font = .systemFont(ofSize: 16, weight: .medium)
        name.textColor = .white
        name.tintColor = .white
        name.delegate = self
        base.addSubview(name)
        self.name = name
        
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = App.shared.user.credentials?.email
        email.clearButtonMode = .never
        email.keyboardType = .emailAddress
        email.keyboardAppearance = .dark
        email.spellCheckingType = .no
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        email.font = .systemFont(ofSize: 16, weight: .medium)
        email.textColor = .white
        email.tintColor = .white
        email.delegate = self
        base.addSubview(email)
        self.email = email
        
        let border = UIView()
        border.backgroundColor = .shade
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        base.addSubview(border)
        
        image.bottomAnchor.constraint(equalTo: base.topAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 78).isActive = true
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        base.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        base.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        base.widthAnchor.constraint(equalToConstant: 300).isActive = true
        base.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleName.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        titleName.centerYAnchor.constraint(equalTo: name.centerYAnchor).isActive = true
        
        titleEmail.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        titleEmail.centerYAnchor.constraint(equalTo: email.centerYAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 190).isActive = true
        name.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -20).isActive = true
        name.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        border.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.widthAnchor.constraint(equalToConstant: 210).isActive = true
        
        email.topAnchor.constraint(equalTo: border.bottomAnchor).isActive = true
        email.widthAnchor.constraint(equalToConstant: 190).isActive = true
        email.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -20).isActive = true
        email.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        
        done.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20).isActive = true
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.width.constant = 200
        
        cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(20 + App.shared.margin.bottom)).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: done.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_ field: UITextField) -> Bool {
        if field === name {
            email.becomeFirstResponder()
        } else {
            done()
        }
        return true
    }
    
    @objc private func done() {
        App.shared.endEditing(true)
        do {
            App.shared.user.credentials = try meta.Credentials(name.text!, email: email.text!)
            Alert.shared.add(.local("Credentials.saved"))
            close()
            success()
        } catch {
            Alert.shared.add(error)
        }
    }
}
