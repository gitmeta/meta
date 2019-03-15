import meta
import UIKit

class Document: UIControl {
    let document: Editable
    private weak var label: UILabel!
    
    init(_ document: Editable) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 6
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(14)
        label.text = document.name
        addSubview(label)
        self.label = label
        
        let export = UIButton()
        export.translatesAutoresizingMaskIntoConstraints = false
        export.setImage(#imageLiteral(resourceName: "export.pdf"), for: [])
        export.imageView!.clipsToBounds = true
        export.imageView!.contentMode = .center
        export.addTarget(self, action: #selector(self.export), for: .touchUpInside)
        addSubview(export)
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setImage(#imageLiteral(resourceName: "cancel.pdf"), for: [])
        delete.imageView!.clipsToBounds = true
        delete.imageView!.contentMode = .center
        delete.addTarget(self, action: #selector(remove), for: .touchUpInside)
        addSubview(delete)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: export.leftAnchor).isActive = true
        
        export.topAnchor.constraint(equalTo: topAnchor).isActive = true
        export.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        export.widthAnchor.constraint(equalToConstant: 40).isActive = true
        export.rightAnchor.constraint(equalTo: delete.leftAnchor).isActive = true
        
        delete.topAnchor.constraint(equalTo: topAnchor).isActive = true
        delete.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant: 40).isActive = true
        delete.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if List.shared.selected === self {
            backgroundColor = .halo
            label.textColor = .black
        } else {
            backgroundColor = .shade
            label.textColor = .white
        }
    }
    
    @objc private func export() {
        let view = UIActivityViewController(activityItems: [document.url], applicationActivities: nil)
        view.popoverPresentationController?.sourceView = self
        view.popoverPresentationController?.sourceRect = .zero
        view.popoverPresentationController?.permittedArrowDirections = .any
        App.shared.rootViewController!.present(view, animated: true)
    }
    
    @objc private func remove() {
        let alert = UIAlertController(title: .local("Document.deleteTitle"), message: document.name, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: .local("Document.deleteCancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: .local("Document.deleteConfirm"), style: .destructive) { _ in
            do {
                try List.shared.folder.delete(self.document)
                List.shared.update()
            } catch { Alert.shared.add(error) }
        })
        App.shared.rootViewController!.present(alert, animated: true)
    }
}
