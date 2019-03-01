import AppKit
import TCR

class Image: NSView {
    init(_ document: TCR.Image) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = NSImage(contentsOf: document.url)
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
