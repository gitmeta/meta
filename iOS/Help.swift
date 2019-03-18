import UIKit
import MessageUI

class Help: Sheet, MFMailComposeViewControllerDelegate {
    @discardableResult init() {
        super.init(true)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "help.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let version = UILabel()
        version.translatesAutoresizingMaskIntoConstraints = false
        version.textColor = .white
        version.font = .light(16)
        version.text = .local("Help.version") + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        version.numberOfLines = 2
        addSubview(version)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .local("Help.title")
        title.font = .bold(16)
        title.textColor = .white
        addSubview(title)
        
        let write = Link(.local("Help.write"), target: self, selector: #selector(self.write))
        addSubview(write)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle(.local("Help.cancel"), for: [])
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        cancel.setTitleColor(UIColor(white: 1, alpha: 0.2), for: .highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize: 15, weight: .medium)
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        addSubview(cancel)

        version.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -30).isActive = true
        
        image.rightAnchor.constraint(equalTo: centerXAnchor, constant: -20).isActive = true
        image.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        write.topAnchor.constraint(equalTo: image.topAnchor, constant: 15).isActive = true
        write.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 20).isActive = true
        
        cancel.leftAnchor.constraint(equalTo: write.leftAnchor).isActive = true
        cancel.rightAnchor.constraint(equalTo: write.rightAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: write.bottomAnchor, constant: 15).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if #available(iOS 11.0, *) {
            version.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        } else {
            version.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        close()
    }
    
    @objc private func write() {
        guard MFMailComposeViewController.canSendMail() else { return }
        let view = MFMailComposeViewController()
        view.mailComposeDelegate = self
        view.setToRecipients(["meta@iturbi.de"])
        view.setSubject(.local("Help.subject"))
        App.shared.rootViewController!.present(view, animated: true)
    }
}
