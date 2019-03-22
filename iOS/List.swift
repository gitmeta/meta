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
    private weak var contentBottom: NSLayoutConstraint? { didSet { oldValue?.isActive = false; contentBottom?.isActive = true } }
    
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
            guard let last = self.render($0, origin: self.topAnchor, margin: 60 + App.shared.margin.top, parent: nil) else { return }
            self.align(last)
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
    
    private func expand(_ document: Document) {
        folder.documents(document.document.url) {
            let sibling = self.content.subviews.compactMap({ $0 as? Document }).first(where: { $0.top?.secondItem === document })
            guard let last = self.render($0, origin: document.bottomAnchor, margin: 0, parent: document) else { return }
            if let sibling = sibling {
                sibling.top = sibling.topAnchor.constraint(equalTo: last.bottomAnchor)
            } else {
                self.align(last)
            }
        }
    }
    
    private func collapse(_ document: Document) {
        if let sibling = content.subviews.compactMap({ $0 as? Document }).filter({ $0.parent !== document }).first(where:
            { ($0.top?.secondItem as? Document)?.parent === document }) {
            sibling.top = sibling.topAnchor.constraint(equalTo: document.bottomAnchor)
        } else {
            if (bottom?.secondItem as? Document)?.parent === document {
                align(document)
            }
        }
        content.subviews.compactMap({ $0 as? Document }).filter({ $0.parent === document }).forEach {
            collapse($0)
            $0.removeFromSuperview()
        }
    }
    
    private func render(_ documents: [meta.Document],
                        origin: NSLayoutYAxisAnchor, margin: CGFloat, parent: Document?) -> Document? {
        return documents.reduce((nil, origin, margin)) {
            let document = Document($1, indent: parent == nil ? 0 : parent!.indent + 1)
            document.parent = parent
            document.addTarget(self, action: #selector(self.open(_:)), for: .touchUpInside)
            content.addSubview(document)
            
            document.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            document.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            document.top = document.topAnchor.constraint(equalTo: $0.1, constant: $0.2)
            return (document, document.bottomAnchor, 0)
            }.0
    }
    
    private func align(_ bottom: UIView) {
        self.contentBottom = content.bottomAnchor.constraint(greaterThanOrEqualTo: bottom.bottomAnchor, constant: 30)
    }
    
    @objc private func open(_ item: Document) {
        guard !App.shared.creating else { return }
        if item.document is meta.Directory {
            item.isSelected.toggle()
            item.isSelected ? expand(item) : collapse(item)
        } else {
            selected = item
            Bar.shared.document(item.document.name)
            Display.shared.open(item.document)
            hide()
        }
    }
}
