import meta
import UIKit

class Text: UITextView, UITextViewDelegate {
    weak var ruler: Ruler!
    
    init(_ document: Editable) {
        let storage = Storage()
        super.init(frame: .zero, textContainer: {
            storage.addLayoutManager($1)
            $1.addTextContainer($0)
            $0.lineBreakMode = .byCharWrapping
            return $0
        } (NSTextContainer(), Layout()) )
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isScrollEnabled = false
        bounces = false
        textColor = .white
        tintColor = .halo
        font = .light(Skin.font)
        text = document.content
        keyboardAppearance = .dark
        autocorrectionType = .no
        spellCheckingType = .no
        autocapitalizationType = .none
        contentInset = .zero
        delegate = self
        
        let ruler = Ruler(self, layout: layoutManager as! Layout)
        addSubview(ruler)
        
        ruler.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        ruler.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
        ruler.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ruler.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.ruler = ruler
        
        textContainerInset = UIEdgeInsets(top: 60, left: ruler.thickness + 5, bottom: 20, right: 12)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.width += 2
        return rect
    }
    
    func textViewDidChange(_: UITextView) { update() }
    func textViewDidBeginEditing(_: UITextView) { update() }
    private func update() { DispatchQueue.main.async { self.ruler.setNeedsDisplay() } }
}
