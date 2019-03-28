import meta
import UIKit

class Git: UIView {
    static let shared = Git()
    let git = meta.Git()
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
        text.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        text.isEditable = false
        addSubview(text)
        self.text = text
        
        let clear = UIButton()
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.layer.cornerRadius = 4
        clear.backgroundColor = UIColor(white: 0.2, alpha: 0.7)
        clear.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        clear.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        clear.setTitle(.local("Console.clear"), for: [])
        clear.titleLabel!.font = .systemFont(ofSize: 11, weight: .light)
        clear.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        addSubview(clear)
        
        let status = link("status", selector: #selector(self.status))
        let commit = link("commit", selector: #selector(self.commit))
        
        commit.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10).isActive = true
        
        text.topAnchor.constraint(equalTo: commit.bottomAnchor, constant: 4).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        clear.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        clear.widthAnchor.constraint(equalToConstant: 60).isActive = true
        clear.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        if #available(iOS 11.0, *) {
            status.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            clear.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            status.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
            clear.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        }
        
        format.dateStyle = .none
        format.timeStyle = .medium
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
    
    @objc func create() {
        do {
            try git.create(App.shared.user.access!.url)
            log(.local("Git.init"))
        } catch { Alert.shared.add(error) }
    }
    
    private func link(_ title: String, selector: Selector) -> Link {
        return {
            $0.backgroundColor = .shade
            $0.setTitleColor(.halo, for: .normal)
            $0.setTitleColor(UIColor.halo.withAlphaComponent(0.2), for: .highlighted)
            addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            $0.width.constant = 120
            return $0
        } (Link(title, target: self, selector: selector))
    }
    
    @objc private func status() {
        do {
            try git.status {
                self.log($0.description.appending($0.commitable ? String() : .local("Git.notCommitable")))
            }
        } catch { Alert.shared.add(error) }
    }
    
    @objc private func commit() {
        do {
            try git.status { status in
                if status.commitable {
                    DispatchQueue.main.async { Commit(status) }
                } else {
                    self.log(.local("Git.notCommitable"))
                }
            }
        } catch { Alert.shared.add(error) }
    }
    
    @objc private func clear() { text.text = String() }
}
