import meta
import UIKit

class List: UIScrollView, UITextFieldDelegate {
    static let shared = List()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    var bottom: NSLayoutConstraint! { didSet { bottom.isActive = true } }
    var open: NSLayoutConstraint! { didSet { open.isActive = true } }
    var close: NSLayoutConstraint!
    let folder = Folder()
    private weak var content: UIView!
    private weak var base: UIView!
    private weak var field: UITextField!
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        self.content = content
        
        let image = UIImageView(image: #imageLiteral(resourceName: "welcome.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        content.addSubview(image)
        
        let create = UIButton()
        create.translatesAutoresizingMaskIntoConstraints = false
        create.addTarget(self, action: #selector(self.create), for: .touchUpInside)
        create.setImage(#imageLiteral(resourceName: "new.pdf"), for: [])
        create.imageView!.clipsToBounds = true
        create.imageView!.contentMode = .center
        content.addSubview(create)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        base.isHidden = true
        content.addSubview(base)
        self.base = base
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = .halo
        field.textColor = .black
        field.delegate = self
        field.font = .light(16)
        field.placeholder = .local("List.new")
        base.addSubview(field)
        self.field = field
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        cancel.setImage(#imageLiteral(resourceName: "cancel.pdf"), for: [])
        cancel.imageView!.clipsToBounds = true
        cancel.imageView!.contentMode = .center
        base.addSubview(cancel)
        
        let confirm = Link(.local("List.cofirm"), target: self, selector: #selector(self.confirm))
        base.addSubview(confirm)
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        content.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        content.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor).isActive = true
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        create.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        create.leftAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        create.widthAnchor.constraint(equalToConstant: 60).isActive = true
        create.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        field.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        field.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 140).isActive = true
        field.leftAnchor.constraint(equalTo: cancel.rightAnchor).isActive = true
        
        base.heightAnchor.constraint(equalToConstant: 48).isActive = true
        base.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        base.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        cancel.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        cancel.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        confirm.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
        confirm.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -20).isActive = true
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
            image.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            image.topAnchor.constraint(equalTo: content.topAnchor, constant: 20).isActive = true
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {
            self.bottom.constant = {
                $0.minY < self.bounds.height ? -$0.height : 0
            } (($0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
            UIView.animate(withDuration:
            ($0.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) { self.layoutIfNeeded() }
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        field.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        base.isHidden = true
    }
    
    func update() {
        /*guard let name = App.shared.user.folder else { return }
        App.shared.state = .folder
        title.stringValue = name
        folder.documents(App.shared.user) {
            var top = self.topAnchor
            $0.enumerated().forEach {
                let document = Document($0.1)
                self.documentView!.addSubview(document)
                
                document.widthAnchor.constraint(equalToConstant: self.open + 10).isActive = true
                document.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                document.topAnchor.constraint(equalTo: top, constant: $0.0 == 0 ? 80 : 0).isActive = true
                top = document.bottomAnchor
            }
            if self.topAnchor !== top {
                self.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
            }
        }*/
    }
    
    @objc func show() {
        
    }
    
    @objc private func create() {
        base.isHidden = false
        field.becomeFirstResponder()
    }
    
    @objc private func cancel() {
        field.text = String()
        field.resignFirstResponder()
    }
    
    @objc private func confirm() {
        field.resignFirstResponder()
    }
    
    @objc private func open(_ item: Document) {
        App.shared.endEditing(true)
        selected = item
//        open.isActive = false
//        close.isActive = true
//        Display.shared.open(item.document)
    }
}
