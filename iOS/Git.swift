import meta
import UIKit

class Git: UIView {
    static let shared = Git()
    private weak var text: UITextView!
    private let git = meta.Git()
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
        text.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        text.isEditable = false
        self.text = text
        addSubview(text)
        
        let create = Link("init", target: self, selector: #selector(self.create))
        addSubview(create)
        
        let status = Link("status", target: self, selector: #selector(self.status))
        addSubview(status)
        
        create.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        create.width.constant = 100
        
        status.topAnchor.constraint(equalTo: create.bottomAnchor).isActive = true
        status.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        status.width.constant = 100
        
        text.topAnchor.constraint(equalTo: status.bottomAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            create.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        } else {
            create.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        }
        
        format.dateStyle = .none
        format.timeStyle = .medium
        log("hello world")
        meta.Libgit.shared = Libgit()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        git.url(App.shared.user.access!.url)
    }
    
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
    
    @objc private func create() {
        do {
            try git.create(App.shared.user.access!.url)
            log(.local("Git.init"))
        } catch { Alert.shared.add(error) }
    }
    
    @objc private func status() {
        do {
            try git.status { self.log($0) }
        } catch { Alert.shared.add(error) }
    }
}
