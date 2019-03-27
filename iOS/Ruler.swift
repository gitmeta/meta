import UIKit

class Ruler: UIView {
    let thickness = CGFloat(30)
    private weak var text: Text!
    private weak var layout: Layout!
    
    init(_ text: Text, layout: Layout) {
        super.init(frame: .zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: thickness).isActive = true
        self.text = text
        self.layout = layout
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func draw(_ rect: CGRect) {
        UIGraphicsGetCurrentContext()!.clear(rect)
        var numbers = [(Int, CGFloat, CGFloat)]()
        let range = layout.glyphRange(for: text.textContainer)
        var i = 0
        var c = range.lowerBound
        while c < range.upperBound {
            i += 1
            let end = layout.glyphRange(forCharacterRange: NSRange(location: text.text.lineRange(for:
                Range(NSRange(location: c, length: 0), in: text.text)!).upperBound.utf16Offset(in: text.text), length: 0),
                                        actualCharacterRange: nil).upperBound
            numbers.append((i, layout.lineFragmentRect(forGlyphAt: c, effectiveRange: nil, withoutAdditionalLayout: true).minY,
            !text.isFirstResponder ? 0 : {
                ($0.lowerBound < end && $0.upperBound > c) ||
                $0.upperBound == c ||
                (layout.extraLineFragmentTextContainer == nil && $0.upperBound == end && end == range.upperBound) ? 0.6 : 0
            } (text.selectedRange)))
            c = end
        }
        if layout.extraLineFragmentTextContainer != nil {
            numbers.append((i + 1, layout.extraLineFragmentRect.minY, text.isFirstResponder && text.selectedRange.lowerBound == c ?
                0.6 : 0))
        }
        let y = text.textContainerInset.top + layout.padding
        numbers.map({ (NSAttributedString(string: String($0.0), attributes:
            [.foregroundColor: UIColor(white: 1, alpha: 0.3 + $0.2), .font: UIFont.light(14)]), $0.1) })
            .forEach { $0.0.draw(at: CGPoint(x: thickness - $0.0.size().width, y: $0.1 + y)) }
    }
}
