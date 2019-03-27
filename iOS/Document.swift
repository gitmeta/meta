import meta
import UIKit

class Document: UIControl {
    weak var parent: Document?
    weak var top: NSLayoutConstraint? { didSet { oldValue?.isActive = false; top?.isActive = true } }
    let document: meta.Document
    let indent: CGFloat
    override var isHighlighted: Bool { didSet { update() } }
    override var isSelected: Bool { didSet { update() } }
    private weak var label: UILabel!
    private weak var image: UIImageView!
    
    init(_ document: meta.Document, indent: CGFloat) {
        self.document = document
        self.indent = indent
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        addSubview(image)
        self.image = image
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .light(14)
        label.text = document.name
        label.textColor = .white
        addSubview(label)
        self.label = label
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        image.widthAnchor.constraint(equalToConstant: 32).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10 + (indent * 40)).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        if document is meta.Directory {
            image.contentMode = .center
        } else {
            image.contentMode = .scaleAspectFit
            image.image = UIDocumentInteractionController(url: document.url).icons.last!
        }
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        if document is meta.Directory {
            image.image = isSelected ? #imageLiteral(resourceName: "collapse.pdf") : #imageLiteral(resourceName: "expand.pdf")
            backgroundColor = isHighlighted ? UIColor(white: 1, alpha: 0.1) : .clear
        } else {
            if List.shared.selected === self || isHighlighted || isSelected {
                backgroundColor = UIColor(white: 1, alpha: 0.1)
            } else {
                backgroundColor = .clear
            }
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
