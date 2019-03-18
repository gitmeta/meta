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
    
    func open(_ document: Editable) {
        let text = Text(document)
        addSubview(text)
        isHidden = false
        
        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        text.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        layoutIfNeeded()
    }
}
