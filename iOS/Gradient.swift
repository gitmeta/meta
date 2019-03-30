import UIKit

class Gradient: UIView {
    class func top() -> UIView {
        return {
            ($0.layer as! CAGradientLayer).locations = [0, 0.75, 1]
            ($0.layer as! CAGradientLayer).colors = [UIColor(white: 0, alpha: 0.9).cgColor,
                                                     UIColor(white: 0, alpha: 0.6).cgColor,
                                                     UIColor(white: 0, alpha: 0).cgColor]
            return $0
        } (Gradient())
    }
    
    class func bottom() -> UIView {
        return {
            ($0.layer as! CAGradientLayer).locations = [0, 0.25, 1]
            ($0.layer as! CAGradientLayer).colors = [UIColor(white: 0, alpha: 0).cgColor,
                                                     UIColor(white: 0, alpha: 0.6).cgColor,
                                                     UIColor(white: 0, alpha: 0.9).cgColor]
            return $0
            } (Gradient())
    }
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
    }
    
    required init?(coder: NSCoder) { return nil }
}
