import meta
import UIKit

class Create: UIView, UITextFieldDelegate {
    weak var bottom: NSLayoutConstraint!
    private(set) weak var field: UITextField!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .shade
        layer.cornerRadius = 6
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = .local("Create.title")
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(white: 1, alpha: 0.4)
        addSubview(label)
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = .halo
        field.textColor = .white
        field.delegate = self
        field.font = .light(16)
        addSubview(field)
        self.field = field
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        cancel.setImage(#imageLiteral(resourceName: "cancel.pdf"), for: [])
        cancel.imageView!.clipsToBounds = true
        cancel.imageView!.contentMode = .center
        addSubview(cancel)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white: 1, alpha: 0.2)
        addSubview(border)
        
        let confirm = Link(.local("Create.confirm"), target: self, selector: #selector(self.confirm))
        addSubview(confirm)
        
        label.centerYAnchor.constraint(equalTo: cancel.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
        
        field.topAnchor.constraint(equalTo: cancel.bottomAnchor).isActive = true
        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        field.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        border.topAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        cancel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cancel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        confirm.centerYAnchor.constraint(equalTo: cancel.centerYAnchor).isActive = true
        confirm.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        confirm()
        return true
    }
    
    private func close() {
        bottom.constant = 300
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.superview?.layoutIfNeeded()
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    @objc private func cancel() {
        field.resignFirstResponder()
        close()
    }
    
    @objc private func confirm() {
        field.resignFirstResponder()
        do {
            try List.shared.folder.create(field.text!, user: App.shared.user)
            close()
        } catch { Alert.shared.add(error) }
    }
}