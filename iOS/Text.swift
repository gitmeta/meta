import meta
import UIKit

class Text: UITextView {
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
        tintColor = .halo
        keyboardAppearance = .dark
        autocorrectionType = .no
        spellCheckingType = .no
        autocapitalizationType = .none
        contentInset = .zero
        textContainerInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        inputAccessoryView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 54))
        inputAccessoryView!.backgroundColor = .shade
        keyboardDismissMode = .onDrag
        
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
}
