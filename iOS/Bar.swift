import UIKit

class Bar: UIView {
    static let shared = Bar()
    private var closed: NSLayoutConstraint! { didSet { closed.isActive = true } }
    private var opened: NSLayoutConstraint!
    private weak var title: UILabel!
    private weak var list: UIButton!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let help = button(#imageLiteral(resourceName: "info.pdf"), target: self, action: #selector(self.help))
        let git = button(#imageLiteral(resourceName: "gitOn.pdf"), target: List.shared, action: #selector(List.shared.git))
        let create = button(#imageLiteral(resourceName: "new.pdf"), target: List.shared, action: #selector(List.shared.create))
        let welcome = button(#imageLiteral(resourceName: "up.pdf"), target: self, action: #selector(self.welcome))
        let list = button(#imageLiteral(resourceName: "listOn.pdf"), target: List.shared, action: #selector(List.shared.show))
        list.alpha = 0
        self.list = list
        
        let title = UILabel()
        title.alpha = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .bold(18)
        title.textColor = .halo
        addSubview(title)
        self.title = title
        
        closed = help.leftAnchor.constraint(equalTo: leftAnchor)
        opened = help.leftAnchor.constraint(equalTo: rightAnchor)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        git.leftAnchor.constraint(equalTo: help.rightAnchor).isActive = true
        create.leftAnchor.constraint(equalTo: git.rightAnchor).isActive = true
        welcome.leftAnchor.constraint(equalTo: create.rightAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: list.rightAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func document(_ title: String) {
        closed.isActive = false
        opened.isActive = true
        self.title.text = title
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 1
            self.list.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func git() {
        closed.isActive = false
        opened.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.list.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func close() {
        opened.isActive = false
        closed.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.title.alpha = 0
            self.list.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    private func button(_ image: UIImage, target: AnyObject, action: Selector) -> UIButton {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(target, action: action, for: .touchUpInside)
            $0.setImage(image, for: [])
            $0.imageView!.clipsToBounds = true
            $0.imageView!.contentMode = .center
            addSubview($0)
            
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
            return $0
        } (UIButton())
    }
    
    @objc private func welcome() { Welcome() }
    
    @objc private func help() {
        if !App.shared.creating {
            Help()
        }
    }
}
