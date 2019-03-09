import AppKit

class Ruler: NSRulerView {
    static let thickness = CGFloat(30)
    private weak var text: Text!
    private weak var layout: Layout!
    
    init(_ text: Text, layout: Layout) {
        super.init(scrollView: nil, orientation: .verticalRuler)
        ruleThickness = Ruler.thickness
        self.text = text
        self.layout = layout
    }
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    
    override func draw(_: NSRect) {
        var numbers = [(Int, CGFloat, CGFloat)]()
        let range = layout.glyphRange(forBoundingRect: text.visibleRect, in: text.textContainer!)
        var i = (try! NSRegularExpression(pattern: "\n")).numberOfMatches(in: text.string,
                                                                          range: NSMakeRange(0, range.location))
        var c = range.lowerBound
        while c < range.upperBound {
            i += 1
            let end = layout.glyphRange(forCharacterRange: NSRange(location: text.string.lineRange(for:
                Range(NSRange(location: c, length: 0), in: text.string)!).upperBound.encodedOffset, length: 0),
                                        actualCharacterRange: nil).upperBound
            numbers.append((i, layout.lineFragmentRect(forGlyphAt: c, effectiveRange: nil,
                                                       withoutAdditionalLayout: true).minY, {
            (layout.extraLineFragmentTextContainer == nil && $0.lowerBound == end) || ($0.lowerBound < end && $0.upperBound >= c) ?
                0.7 : 0.4
            } (text.selectedRange())))
            c = end
        }
        if layout.extraLineFragmentTextContainer != nil {
            numbers.append((i + 1, layout.extraLineFragmentRect.minY, text.selectedRange().lowerBound == c ? 0.7 : 0.4))
        }
        let y = convert(NSZeroPoint, from: text).y + text.textContainerInset.height + (layout.padding / 2)
        numbers.map({ (NSAttributedString(string: String($0.0), attributes:
            [.foregroundColor: NSColor(white: 1, alpha: $0.2), .font: NSFont.light(14)]), $0.1) })
            .forEach { $0.0.draw(at: CGPoint(x: ruleThickness - $0.0.size().width, y: $0.1 + y)) }
    }
    
    override func drawHashMarksAndLabels(in: NSRect) { }
}
