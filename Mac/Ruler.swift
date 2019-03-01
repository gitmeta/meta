import AppKit

class Ruler: NSRulerView {
    static let thickness = CGFloat(40)
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
        var numbers = [(Int, CGFloat)]()
        let range = layout.glyphRange(forBoundingRect: text.visibleRect, in: text.textContainer!)
        var i = (try! NSRegularExpression(pattern: "\n")).numberOfMatches(in: text.string,
                                                                          range: NSMakeRange(0, range.location))
        var c = range.lowerBound
        while c < range.upperBound {
            i += 1
            numbers.append((i, layout.lineFragmentRect(forGlyphAt: c, effectiveRange: nil,
                                                              withoutAdditionalLayout: true).minY))
            
            c = layout.glyphRange(forCharacterRange: NSRange(location: text.string.lineRange(for:
                Range(NSRange(location: c, length: 0), in: text.string)!).upperBound.encodedOffset, length: 0),
                                         actualCharacterRange: nil).upperBound
        }
        if layout.extraLineFragmentTextContainer != nil {
            numbers.append((i + 1, layout.extraLineFragmentRect.minY))
        }
        let y = convert(NSZeroPoint, from: text).y + text.textContainerInset.height + layout.padding
        numbers.map({ (NSAttributedString(string: String($0.0), attributes:
            [.foregroundColor: NSColor(white: 1, alpha: 0.4), .font: NSFont.light(14)]), $0.1) })
            .forEach { $0.0.draw(at: CGPoint(x: ruleThickness - $0.0.size().width, y: $0.1 + y)) }
    }
    
    override func drawHashMarksAndLabels(in: NSRect) { }
}
