import UIKit

class Credentials: Sheet {
    @discardableResult init(_ done: @escaping(() -> Void)) {
        super.init(true)
        backgroundColor = .black
        
        let image = UIImageView(image: #imageLiteral(resourceName: "credentials.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .shade
        base.layer.cornerRadius = 20
        addSubview(base)
        
        let done = Link(.local("Credentials.done"), target: self, selector: #selector(self.done))
        addSubview(done)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        cancel.setTitle(.local("Credentials.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 14, weight: .light)
        addSubview(cancel)
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30 + App.shared.margin.top).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 78).isActive = true
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        base.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        base.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        base.widthAnchor.constraint(equalToConstant: 300).isActive = true
        base.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        done.topAnchor.constraint(equalTo: base.bottomAnchor, constant: 40).isActive = true
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.width.constant = 200
        
        cancel.topAnchor.constraint(equalTo: done.bottomAnchor, constant: 20).isActive = true
        cancel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: done.widthAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func done() {
        
    }
}
