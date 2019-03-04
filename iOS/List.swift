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
        
        let image = UIImageView(image: #imageLiteral(resourceName: "welcome.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        content.addSubview(image)
        
        let create = Link(.local("List.create"), target: self, selector: #selector(self.create))
        content.addSubview(create)
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
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
        
    }
    
    @objc private func open(_ item: Document) {
        App.shared.endEditing(true)
        selected = item
//        open.isActive = false
//        close.isActive = true
//        Display.shared.open(item.document)
    }
}
