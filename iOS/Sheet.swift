import UIKit

class Sheet: UIView {
    init() {
        App.shared.endEditing(true)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        App.shared.rootViewController!.view.addSubview(self)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.isUserInteractionEnabled = false
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        
        blur.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        topAnchor.constraint(equalTo: App.shared.rootViewController!.view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: App.shared.rootViewController!.view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: App.shared.rootViewController!.view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: App.shared.rootViewController!.view.rightAnchor).isActive = true
        
        UIView.animate(withDuration: 0.4) { [weak self] in self?.alpha = 1 }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc func close() {
        App.shared.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in self?.removeFromSuperview() }
    }
}
