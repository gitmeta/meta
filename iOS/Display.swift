import meta
import UIKit

class Display: UIScrollView {
    static let shared = Display()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
        isHidden = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func clear() {
        subviews.forEach({ $0.removeFromSuperview() })
        scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        isHidden = true
    }
    
    func open(_ document: meta.Document) {
        clear()
        switch document {
        case let document as meta.Image: configure(Image(document))
        case let document as meta.Pdf: configure(Pdf(document))
        case let document as Editable: configure(Text(document))
        default: break
        }
    }
    
    private func configure(_ view: UIView) {
        addSubview(view)
        isHidden = false
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        view.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        layoutIfNeeded()
    }
}
