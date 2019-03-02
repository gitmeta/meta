import UIKit

@UIApplicationMain class App: UIWindow, UIApplicationDelegate {
    static private(set) weak var shared: App!
    var margin = UIEdgeInsets.zero
    
    func application(_: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        App.shared = self
        makeKeyAndVisible()
        rootViewController = UIViewController()
        if #available(iOS 11.0, *) { margin = rootViewController!.view.safeAreaInsets }
        
        let splash = Splash()
        rootViewController!.view.addSubview(splash)
        self.splash = splash
        
        splash.topAnchor.constraint(equalTo:rootViewController!.view.topAnchor).isActive = true
        splash.bottomAnchor.constraint(equalTo:rootViewController!.view.bottomAnchor).isActive = true
        splash.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor).isActive = true
        splash.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor).isActive = true
        
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self)
        outlets()
        DispatchQueue.global(qos:.background).async {
            Repository.shared.load()
            Skin.update()
            DispatchQueue.main.async {
                self.splash?.button.isHidden = false
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
    
    @objc func newBoard() { Boarder() }
    
    private func outlets() {
        let bar = Bar.shared
        let list = List.shared
        let canvas = Canvas.shared
        let gradientTop = GradientTop()
        let gradientBottom = GradientBottom()
        let progress = Progress.shared
        let search = Search.shared
        
        if splash == nil {
            rootViewController!.view.addSubview(list)
        } else {
            rootViewController!.view.insertSubview(list, belowSubview:splash!)
        }
        rootViewController!.view.addSubview(canvas)
        rootViewController!.view.addSubview(gradientTop)
        rootViewController!.view.addSubview(gradientBottom)
        rootViewController!.view.addSubview(progress)
        rootViewController!.view.addSubview(search)
        rootViewController!.view.addSubview(bar)
        
        gradientTop.topAnchor.constraint(equalTo:rootViewController!.view.topAnchor).isActive = true
        gradientTop.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor).isActive = true
        gradientTop.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor).isActive = true
        
        gradientBottom.bottomAnchor.constraint(equalTo:rootViewController!.view.bottomAnchor).isActive = true
        gradientBottom.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor).isActive = true
        gradientBottom.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor).isActive = true
        
        list.widthAnchor.constraint(equalTo:rootViewController!.view.widthAnchor).isActive = true
        list.topAnchor.constraint(equalTo:rootViewController!.view.topAnchor).isActive = true
        list.bottom = list.bottomAnchor.constraint(equalTo:rootViewController!.view.bottomAnchor)
        list.open = list.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor)
        list.closed = list.leftAnchor.constraint(equalTo:rootViewController!.view.rightAnchor)
        list.open.isActive = true
        
        canvas.topAnchor.constraint(equalTo:list.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo:list.bottomAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        canvas.widthAnchor.constraint(equalTo:rootViewController!.view.widthAnchor).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:rootViewController!.view.bottomAnchor, constant:-15).isActive = true
        progress.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor, constant:5).isActive = true
        progress.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor, constant:-5).isActive = true
        
        search.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor, constant:10).isActive = true
        search.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor, constant:-10).isActive = true
        search.bottom = search.bottomAnchor.constraint(equalTo:rootViewController!.view.topAnchor)
        
        bar.leftAnchor.constraint(equalTo:rootViewController!.view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:rootViewController!.view.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            bar.topAnchor.constraint(equalTo:rootViewController!.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            bar.topAnchor.constraint(equalTo:rootViewController!.view.topAnchor).isActive = true
        }
    }
}
