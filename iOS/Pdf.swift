import meta
import UIKit
import PDFKit

class Pdf: UIView {
    init(_ document: meta.Pdf) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            let pdf = PDFView()
            pdf.translatesAutoresizingMaskIntoConstraints = false
            pdf.backgroundColor = .clear
            addSubview(pdf)
            
            pdf.topAnchor.constraint(equalTo: topAnchor).isActive = true
            pdf.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            pdf.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
            pdf.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            DispatchQueue.global(qos: .background).async {
                let document = PDFDocument(url: document.url)
                DispatchQueue.main.async { [weak pdf] in
                    pdf?.document = document
                }
            }
        }
    }
    
    required init?(coder: NSCoder) { return nil }
}
