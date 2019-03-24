import meta
import UIKit

class Commit: Sheet {
    private let status: Status
    
    @discardableResult init(_ status: Status) {
        self.status = status
        super.init(true)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .local("Commit.title")
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textColor = .white
        addSubview(title)
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        if #available(iOS 11.0, *) {
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        }
    }
    
    required init?(coder: NSCoder) { return nil }
}
