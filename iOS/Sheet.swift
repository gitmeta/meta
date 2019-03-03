import UIKit

class Sheet: UIView {
    init() {
        App.shared.endEditing(true)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        App.shared.rootViewController!.view.addSubview(self)
        
        topAnchor.constraint(equalTo: App.shared.rootViewController!.view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: App.shared.rootViewController!.view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: App.shared.rootViewController!.view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: App.shared.rootViewController!.view.rightAnchor).isActive = true
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.alpha = 1
        }) { [weak self] _ in self?.ready() }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func ready() { }
    
    @objc func close() {
        App.shared.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in self?.removeFromSuperview() }
    }
}
