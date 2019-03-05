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
                $0.minY < self.bounds.height ? -$0.height : 0
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
                
                document.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
                document.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
                document.topAnchor.constraint(equalTo: top, constant: $0.0 == 0 ? 70 + App.shared.margin.top : 10).isActive = true
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
            Display.shared.clear()
        }
    }
    
    @objc func create() {
        guard superview!.subviews.first(where: { $0 is Create }) == nil else { return }
        let create = Create()
        superview!.addSubview(create)
        
        create.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        create.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        create.heightAnchor.constraint(equalToConstant: 300).isActive = true
        create.bottom = create.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 300)
        create.bottom.isActive = true
        superview!.layoutIfNeeded()
        create.bottom.constant = 150
        
        UIView.animate(withDuration: 0.3, animations: {
            self.superview!.layoutIfNeeded()
            self.content.alpha = 0.4
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
    
    @objc private func open(_ item: Document) {
        guard superview!.subviews.first(where: { $0 is Create }) == nil else { return }
        selected = item
        Bar.shared.open(item.document.name)
        Display.shared.open(item.document)
        open.isActive = false
        close.isActive = true
        UIView.animate(withDuration: 0.4) {
            self.superview!.layoutIfNeeded()
        }
    }
}
