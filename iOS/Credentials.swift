import meta
import UIKit

class Credentials: Sheet, UITextFieldDelegate {
    private var success: (() -> Void)!
    private weak var user: UITextField!
    private weak var email: UITextField!
    private weak var password: UITextField!
    
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
        
        let titleUser = UILabel()
        titleUser.translatesAutoresizingMaskIntoConstraints = false
        titleUser.font = .systemFont(ofSize: 16, weight: .bold)
        titleUser.textColor = UIColor(white: 1, alpha: 0.35)
        titleUser.text = .local("Credentials.user")
        base.addSubview(titleUser)
        
        let titleEmail = UILabel()
        titleEmail.translatesAutoresizingMaskIntoConstraints = false
        titleEmail.font = .systemFont(ofSize: 16, weight: .bold)
        titleEmail.textColor = UIColor(white: 1, alpha: 0.35)
        titleEmail.text = .local("Credentials.email")
        base.addSubview(titleEmail)
        
        let titlePassword = UILabel()
        titlePassword.translatesAutoresizingMaskIntoConstraints = false
        titlePassword.font = .systemFont(ofSize: 16, weight: .bold)
        titlePassword.textColor = UIColor(white: 1, alpha: 0.35)
        titlePassword.text = .local("Credentials.password")
        base.addSubview(titlePassword)
        
        let user = UITextField()
        user.translatesAutoresizingMaskIntoConstraints = false
        user.text = App.shared.user.credentials?.user
        user.clearButtonMode = .never
        user.keyboardType = .alphabet
        user.keyboardAppearance = .dark
        user.spellCheckingType = .no
        user.autocorrectionType = .no
        user.autocapitalizationType = .none
        user.font = .systemFont(ofSize: 16, weight: .medium)
        user.textColor = .white
        user.tintColor = .white
        user.delegate = self
        base.addSubview(user)
        self.user = user
        
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
        
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.clearButtonMode = .never
        password.keyboardType = .alphabet
        password.keyboardAppearance = .dark
        password.spellCheckingType = .no
        password.autocorrectionType = .no
        password.autocapitalizationType = .none
        password.font = .systemFont(ofSize: 16, weight: .medium)
        password.textColor = .white
        password.tintColor = .white
        password.clearsOnInsertion = true
        password.clearsOnBeginEditing = true
        password.isSecureTextEntry = true
        password.delegate = self
        base.addSubview(password)
        self.password = password
        
        let borderTop = UIView()
        borderTop.backgroundColor = .shade
        borderTop.translatesAutoresizingMaskIntoConstraints = false
        borderTop.isUserInteractionEnabled = false
        base.addSubview(borderTop)
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = .shade
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        borderBottom.isUserInteractionEnabled = false
        base.addSubview(borderBottom)
        
        image.bottomAnchor.constraint(equalTo: base.topAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 78).isActive = true
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        base.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
        base.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        base.widthAnchor.constraint(equalToConstant: 300).isActive = true
        base.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleUser.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        titleUser.centerYAnchor.constraint(equalTo: user.centerYAnchor).isActive = true
        
        titleEmail.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        titleEmail.centerYAnchor.constraint(equalTo: email.centerYAnchor).isActive = true
        
        titlePassword.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        titlePassword.centerYAnchor.constraint(equalTo: password.centerYAnchor).isActive = true
        
        user.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        user.widthAnchor.constraint(equalToConstant: 180).isActive = true
        user.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -10).isActive = true
        user.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        borderTop.topAnchor.constraint(equalTo: user.bottomAnchor).isActive = true
        borderTop.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        borderTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderTop.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        email.topAnchor.constraint(equalTo: borderTop.bottomAnchor).isActive = true
        email.widthAnchor.constraint(equalToConstant: 180).isActive = true
        email.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -10).isActive = true
        email.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        borderBottom.topAnchor.constraint(equalTo: email.bottomAnchor).isActive = true
        borderBottom.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        borderBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderBottom.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        password.topAnchor.constraint(equalTo: borderBottom.bottomAnchor).isActive = true
        password.widthAnchor.constraint(equalToConstant: 180).isActive = true
        password.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -10).isActive = true
        password.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        
        done.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20).isActive = true
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.width.constant = 200
        
        cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(20 + App.shared.margin.bottom)).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: done.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ready = { [weak self] in self?.user.becomeFirstResponder() }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_ field: UITextField) -> Bool {
        if field === user {
            email.becomeFirstResponder()
        } else if field === email {
            password.becomeFirstResponder()
        } else {
            field.resignFirstResponder()
        }
        return true
    }
    
    @objc private func done() {
        App.shared.endEditing(true)
        do {
            App.shared.user.credentials = try meta.Credentials(user.text!, email: email.text!, password: password.text!)
            Alert.shared.add(.local("Credentials.saved"))
            close()
            success()
        } catch {
            Alert.shared.add(error)
        }
    }
}
