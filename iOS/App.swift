import meta
import UIKit
import StoreKit

@UIApplicationMain class App: UIWindow, UIApplicationDelegate {
    static private(set) weak var shared: App!
    var margin = UIEdgeInsets.zero
    var creating: Bool { return rootViewController!.view.subviews.first(where: { $0 is Create }) != nil }
    private(set) var user: User!
    
    func application(_: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        App.shared = self
        makeKeyAndVisible()
        rootViewController = UIViewController()
        if #available(iOS 11.0, *) { margin = rootViewController!.view.safeAreaInsets }
        
        let gradient = Gradient()
        
        rootViewController!.view.addSubview(Display.shared)
        rootViewController!.view.addSubview(Git.shared)
        rootViewController!.view.addSubview(List.shared)
        rootViewController!.view.addSubview(gradient)
        rootViewController!.view.addSubview(Bar.shared)
        
        gradient.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        gradient.leftAnchor.constraint(equalTo: rootViewController!.view.leftAnchor).isActive = true
        gradient.rightAnchor.constraint(equalTo: rootViewController!.view.rightAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: Bar.shared.bottomAnchor).isActive = true
        
        List.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        List.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        List.shared.bottom = List.shared.bottomAnchor.constraint(equalTo: rootViewController!.view.bottomAnchor)
        List.shared.open = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.rightAnchor)
        List.shared.close = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.leftAnchor)
        
        Bar.shared.leftAnchor.constraint(equalTo: rootViewController!.view.leftAnchor).isActive = true
        Bar.shared.rightAnchor.constraint(equalTo: rootViewController!.view.rightAnchor).isActive = true
        
        Display.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        Display.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        Display.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        Display.shared.bottomAnchor.constraint(equalTo: List.shared.bottomAnchor).isActive = true
        
        Git.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        Git.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        Git.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        Git.shared.bottomAnchor.constraint(equalTo: List.shared.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            Bar.shared.topAnchor.constraint(equalTo: rootViewController!.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            Bar.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        }
        
        DispatchQueue.global(qos: .background).async {
            self.load()
            DispatchQueue.main.async {
                List.shared.update()
                if self.user.welcome { Welcome(false) }
            }
        }
        
        return true
    }
    
    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            margin = rootViewController!.view.safeAreaInsets
        }
    }
    
    private func load() {
        user = User.load()
        var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = directory.appendingPathComponent("documents")
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try! directory.setResourceValues(resources)
            try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        user.access = Access(url, data: Data())
        user.ask = { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
        Git.shared.update()
    }
}
