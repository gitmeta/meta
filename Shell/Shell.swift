import Foundation

class Shell: NSObject, NSXPCListenerDelegate, Service {
    var url: URL!
    
    func activate(_ url: URL, data: Data) {
        self.url = url
        var stale = false
        _ = (try! URL(resolvingBookmarkData: data, options: .withoutUI, bookmarkDataIsStale:
            &stale)).startAccessingSecurityScopedResource()
    }
    
    func status(_ response: @escaping ((String) -> Void)) {
        Message.send("git status", location: url, response: response)
    }
    
    func commit(_ response: @escaping ((String) -> Void)) {
        Message.send("git add .", location: url) { added in
            Message.send("git commit -m \"meta\"", location: self.url) { committed in
                response(added + committed)
            }
        }
    }
    
    func reset(_ response: @escaping ((String) -> Void)) {
        Message.send("git reset --hard", location: url, response: response)
    }
    
    func pull(_ response: @escaping ((String) -> Void)) {
        Message.send("git pull", location: url, response: response)
    }
    
    func push(_ response: @escaping ((String) -> Void)) {
        Message.send("git push", location: url, response: response)
    }
    
    func listener(_: NSXPCListener, shouldAcceptNewConnection: NSXPCConnection) -> Bool {
        shouldAcceptNewConnection.exportedInterface = NSXPCInterface(with: Service.self)
        shouldAcceptNewConnection.exportedObject = self
        shouldAcceptNewConnection.resume()
        return true
    }
}
