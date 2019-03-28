import meta
import UIKit

class History: Sheet {
    private weak var scroll: UIScrollView!
    private weak var spinner: Spinner?
    
    @discardableResult init() {
        super.init(true)
        
        let spinner = Spinner()
        self.spinner = spinner
        
        let close = UIButton()
        close.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "cancel.pdf"), for: [])
        close.imageView!.clipsToBounds = true
        close.contentMode = .center
        addSubview(close)
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.indicatorStyle = .black
        addSubview(scroll)
        self.scroll = scroll
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white: 1, alpha: 0.1)
        addSubview(border)
        
        close.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant: 70).isActive = true
        close.heightAnchor.constraint(equalToConstant: 70).isActive = true
        close.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -App.shared.margin.bottom).isActive = true
        
        scroll.topAnchor.constraint(equalTo: topAnchor, constant: App.shared.margin.top).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(greaterThanOrEqualTo: close.topAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        try! Git.shared.git.history { items in
            DispatchQueue.main.async { [weak self] in self?.show(items)  }
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func show(_ items: [meta.Commit]) {
        var top = scroll.topAnchor
        items.forEach {
            let item = Historying($0)
            scroll.addSubview(item)
            
            item.topAnchor.constraint(equalTo: top, constant: 20).isActive = true
            item.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            item.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            top = item.bottomAnchor
        }
        scroll.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
        spinner?.close()
    }
}
