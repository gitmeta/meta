import meta
import UIKit

class List: UIScrollView {
    static let shared = List()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    var bottom: NSLayoutConstraint! { didSet { bottom.isActive = true } }
    var open: NSLayoutConstraint! { didSet { open.isActive = true } }
    var close: NSLayoutConstraint!
    let folder = Folder()
    private weak var content: UIView!
    
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

        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        content.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {
            self.bottom.constant = {
                $0.minY < App.shared.frame.height ? -$0.height : 0
            } (($0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
            UIView.animate(withDuration: ($0.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) {
                self.superview!.layoutIfNeeded() } }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        content.subviews.filter({ $0 is Document }).forEach({ $0.removeFromSuperview() })
        folder.documents(App.shared.user) {
            var top = self.topAnchor
            $0.enumerated().forEach {
                let document = Document($0.1)
                document.addTarget(self, action: #selector(self.open(_:)), for: .touchUpInside)
                self.content.addSubview(document)
                
                document.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                document.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                document.topAnchor.constraint(equalTo: top, constant: $0.0 == 0 ? 70 + App.shared.margin.top : 0).isActive = true
                top = document.bottomAnchor
            }
            if self.topAnchor !== self.topAnchor {
                self.content.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 30).isActive = true
            }
        }
    }
    
    @objc func show() {
        App.shared.endEditing(true)
        Bar.shared.close()
        close.isActive = false
        open.isActive = true
        UIView.animate(withDuration: 0.4, animations: {
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.selected = nil
            Git.shared.isHidden = true
            Display.shared.clear()
        }
    }
    
    @objc func git() {
        guard !App.shared.creating else { return }
        Git.shared.isHidden = false
        Bar.shared.git()
        hide()
    }
    
    @objc func create() {
        guard !App.shared.creating else { return }
        let create = Create()
        superview!.addSubview(create)
        
        create.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        create.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        create.heightAnchor.constraint(equalToConstant: 250).isActive = true
        create.bottom = create.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 250)
        create.bottom.isActive = true
        superview!.layoutIfNeeded()
        create.bottom.constant = 70
        
        UIView.animate(withDuration: 0.3, animations: {
            self.superview!.layoutIfNeeded()
            self.content.alpha = 0.5
        }) { _ in
            create.field.becomeFirstResponder()
        }
        
        create.close = {
            create.bottom.constant = 300
            UIView.animate(withDuration: 0.3, animations: {
                self.superview!.layoutIfNeeded()
                self.content.alpha = 1
            }) { _ in create.removeFromSuperview() }
        }
    }
    
    private func hide() {
        open.isActive = false
        close.isActive = true
        UIView.animate(withDuration: 0.4) {
            self.superview!.layoutIfNeeded()
        }
    }
    
    @objc private func open(_ item: Document) {
        guard !App.shared.creating else { return }
        selected = item
        Bar.shared.document(item.document.name)
        if let editable = item.document as? Editable {
            Display.shared.open(editable)
        }
        hide()
    }
}
