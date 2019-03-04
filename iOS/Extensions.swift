import UIKit

extension UIFont {
    class func light(_ size: CGFloat) -> UIFont { return UIFont(name: "SFMono-Light", size: size)! }
    class func bold(_ size: CGFloat) -> UIFont { return UIFont(name: "SFMono-Bold", size: size)! }
}

extension UIColor {
    static let halo = #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1)
    static let shade = #colorLiteral(red: 0.1568627451, green: 0.2156862745, blue: 0.2745098039, alpha: 1)
}
