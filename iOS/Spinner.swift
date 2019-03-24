import UIKit

class Spinner: UIView {
    init() {
        App.shared.endEditing(true)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        alpha = 0
        App.shared.rootViewController!.view.addSubview(self)
        
        topAnchor.constraint(equalTo: App.shared.rootViewController!.view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: App.shared.rootViewController!.view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: App.shared.rootViewController!.view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: App.shared.rootViewController!.view.rightAnchor).isActive = true
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.isUserInteractionEnabled = false
        circle.layer.cornerRadius = 60
        circle.layer.borderWidth = 8
        circle.layer.borderColor = UIColor.halo.cgColor
        addSubview(circle)
        
        let image = UIImageView()
        image.animationImages = [#imageLiteral(resourceName: "loading0.pdf"), #imageLiteral(resourceName: "loading1.pdf")]
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        image.animationDuration = 0.7
        image.animationRepeatCount = 0
        image.startAnimating()
        addSubview(image)
        
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 120).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        UIView.animate(withDuration: 0.2) { [weak self] in self?.alpha = 1 }
    }
    
    required init?(coder: NSCoder) { return nil }
}
