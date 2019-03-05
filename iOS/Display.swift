import meta
import UIKit

class Display: UIScrollView {
    static let shared = Display()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        indicatorStyle = .white
        alwaysBounceVertical = true
        keyboardDismissMode = .interactive
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func clear() { subviews.forEach({ $0.removeFromSuperview() }) }
    
    func open(_ document: meta.Document) {
        let text = Text(document as! Editable)
        addSubview(text)
        
        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        text.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        layoutIfNeeded()
    }
}
