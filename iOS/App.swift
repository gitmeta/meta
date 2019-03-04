import meta
import UIKit
import StoreKit

@UIApplicationMain class App: UIWindow, UIApplicationDelegate {
    static private(set) weak var shared: App!
    var margin = UIEdgeInsets.zero
    private(set) var user: User!
    
    func application(_: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        App.shared = self
        makeKeyAndVisible()
        rootViewController = UIViewController()
        if #available(iOS 11.0, *) { margin = rootViewController!.view.safeAreaInsets }
        
        rootViewController!.view.addSubview(List.shared)
        
        List.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        List.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        List.shared.bottom = List.shared.bottomAnchor.constraint(equalTo: rootViewController!.view.bottomAnchor)
        List.shared.open = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.rightAnchor)
        List.shared.close = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.leftAnchor)
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            self.user.bookmark = [FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0]: Data()]
            self.user.ask = { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
        }
        
        return true
    }
    
    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            margin = rootViewController!.view.safeAreaInsets
        }
    }
}
