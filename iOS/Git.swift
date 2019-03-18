import UIKit

class Git: UIView {
    static let shared = Git()
    private weak var text: UITextView!
    private let format = DateFormatter()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.alwaysBounceVertical = true
        text.contentSize = .zero
        text.textContainerInset = UIEdgeInsets(top: 60, left: 12, bottom: 20, right: 12)
        text.isEditable = false
        self.text = text
        addSubview(text)
        
        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        format.dateStyle = .none
        format.timeStyle = .medium
        log("hello world")
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func log(_ message: String) {
        DispatchQueue.main.async {
            self.text.textStorage.append({
                $0.append(NSAttributedString(string: self.format.string(from: Date()) + " ", attributes: [
                    .font: UIFont.light(14), .foregroundColor: UIColor(white: 1, alpha: 0.6)]))
                $0.append(NSAttributedString(string: message + "\n", attributes: [
                    .font: UIFont.light(14), .foregroundColor: UIColor.white]))
                return $0
                } (NSMutableAttributedString()))
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.text.scrollRangeToVisible(NSMakeRange(self.text.textStorage.length, 0))
                }
            }
        }
    }
}
