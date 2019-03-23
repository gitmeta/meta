import UIKit

class Welcome: Sheet {
    @discardableResult override init(_ animated: Bool = true) {
        super.init(animated)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "welcome.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let create = link(.local("Welcome.create"), selector: #selector(self.create))
        create.isHidden = true
        
        let done = link(.local("Welcome.continue"), selector: #selector(self.done))
        done.isHidden = true
        
        let clone = link(.local("Welcome.clone"), selector: #selector(close))
        
        let check = UIButton()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.setImage(#imageLiteral(resourceName: "checkOff.pdf"), for: .normal)
        check.setImage(#imageLiteral(resourceName: "checkOn.pdf"), for: .selected)
        check.imageView!.clipsToBounds = true
        check.imageView!.contentMode = .center
        check.addTarget(self, action: #selector(check(_:)), for: .touchUpInside)
        check.isSelected = App.shared.user.welcome
        addSubview(check)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = .local("Welcome.show")
        label.textColor = UIColor(white: 1, alpha: 0.7)
        addSubview(label)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.text = .local("Welcome.title")
        title.textColor = .white
        addSubview(title)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        title.leftAnchor.constraint(equalTo: create.leftAnchor).isActive = true
        
        create.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 40).isActive = true
        clone.topAnchor.constraint(equalTo: create.bottomAnchor, constant: 20).isActive = true
        done.topAnchor.constraint(equalTo: create.topAnchor).isActive = true
        
        check.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        check.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        check.widthAnchor.constraint(equalToConstant: 56).isActive = true
        check.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        label.centerYAnchor.constraint(equalTo: check.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: check.rightAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak create, weak done] in
            {
                create?.isHidden = $0
                done?.isHidden = !$0
            } (Git.shared.git.repository == nil)
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func link(_ title: String, selector: Selector) -> Link {
        return {
            addSubview($0)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            $0.width.constant = 220
            return $0
        } (Link(title, target: self, selector: selector))
    }
    
    @objc private func done() {
        Git.shared.log(.local("Welcome.current"))
        close()
    }
    
    @objc private func create() {
        Git.shared.create()
        List.shared.update()
        close()
    }
    
    @objc private func check(_ button: UIButton) {
        button.isSelected.toggle()
        App.shared.user.welcome = button.isSelected
    }
}
