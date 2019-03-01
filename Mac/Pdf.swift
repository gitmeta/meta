import AppKit
import TCR
import WebKit

class Pdf: NSView {
    init(_ document: TCR.Pdf) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        web.loadFileURL(document.url, allowingReadAccessTo: document.url)
        addSubview(web)
        
        web.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
