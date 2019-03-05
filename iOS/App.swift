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
        
        rootViewController!.view.addSubview(Display.shared)
        rootViewController!.view.addSubview(List.shared)
        rootViewController!.view.addSubview(Bar.shared)
        
        List.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        List.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        List.shared.bottom = List.shared.bottomAnchor.constraint(equalTo: rootViewController!.view.bottomAnchor)
        List.shared.open = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.rightAnchor)
        List.shared.close = List.shared.rightAnchor.constraint(equalTo: rootViewController!.view.leftAnchor)
        
        Bar.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        Bar.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        
        Display.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        Display.shared.widthAnchor.constraint(equalTo: rootViewController!.view.widthAnchor).isActive = true
        Display.shared.leftAnchor.constraint(equalTo: List.shared.rightAnchor).isActive = true
        Display.shared.bottomAnchor.constraint(equalTo: List.shared.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            Bar.shared.topAnchor.constraint(equalTo: rootViewController!.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            Bar.shared.topAnchor.constraint(equalTo: rootViewController!.view.topAnchor).isActive = true
        }
        
        DispatchQueue.global(qos: .background).async {
            self.user = User.load()
            self.user.bookmark = [FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0]: Data()]
            self.user.ask = { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
            DispatchQueue.main.async {
                List.shared.update()
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
}
