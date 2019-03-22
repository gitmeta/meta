import meta
import UIKit

class Create: UIView, UITextFieldDelegate {
    var close: (() -> Void)!
    weak var bottom: NSLayoutConstraint!
    private(set) weak var field: UITextField!
    private weak var segmented: UISegmentedControl!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .shade
        layer.borderWidth = 1
        layer.borderColor = UIColor.halo.cgColor
        layer.cornerRadius = 6
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = .local("Create.title")
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .halo
        addSubview(label)
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = .halo
        field.textColor = .white
        field.delegate = self
        field.font = .light(16)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no
        field.clearButtonMode = .never
        field.keyboardAppearance = .dark
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
        border.backgroundColor = .halo
        addSubview(border)
        
        let confirm = Link(.local("Create.confirm"), target: self, selector: #selector(self.confirm))
        addSubview(confirm)
        
        let segmented = UISegmentedControl(items: [String.local("Create.file"), String.local("Create.directory")])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.tintColor = .halo
        segmented.selectedSegmentIndex = 0
        addSubview(segmented)
        self.segmented = segmented
        
        label.centerYAnchor.constraint(equalTo: cancel.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
        
        field.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 20).isActive = true
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        border.topAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        cancel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cancel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        confirm.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        confirm.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        segmented.topAnchor.constraint(equalTo: cancel.bottomAnchor).isActive = true
        segmented.leftAnchor.constraint(equalTo: cancel.leftAnchor,constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        confirm()
        return true
    }
    
    @objc private func cancel() {
        field.resignFirstResponder()
        close()
    }
    
    @objc private func confirm() {
        field.resignFirstResponder()
        if field.text!.isEmpty {
            close()
        } else {
            do {
                if segmented.selectedSegmentIndex == 0 {
                    try List.shared.folder.createFile(field.text!, user: App.shared.user)
                } else {
                    try List.shared.folder.createDirectory(field.text!, user: App.shared.user)
                }
                List.shared.update()
                close()
            } catch { Alert.shared.add(error) }
        }
    }
}
