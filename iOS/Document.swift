import meta
import UIKit

class Document: UIControl {
    let document: meta.Document
    override var isHighlighted: Bool { didSet { update() } }
    override var isSelected: Bool { didSet { update() } }
    private weak var label: UILabel!
    
    init(_ document: meta.Document) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = UIDocumentInteractionController(url: document.url).icons.last!
        addSubview(image)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(14)
        label.text = document.name
        addSubview(label)
        self.label = label
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if List.shared.selected === self || isHighlighted || isSelected {
            backgroundColor = .halo
            label.textColor = .black
        } else {
            backgroundColor = .clear
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
