import Foundation

class Shell: NSObject, NSXPCListenerDelegate, Service {
    func status(_ url: URL, response: @escaping ((String) -> Void)) {
        Message.send("git status", location: url, response: response)
    }
    
    func commit(_ url: URL, response: @escaping ((String) -> Void)) {
        Message.send("git add .", location: url) { added in
            Message.send("git commit -m \"meta\"", location: url) { committed in
                response(added + committed)
            }
        }
    }
    
    func reset(_ url: URL, response: @escaping ((String) -> Void)) {
        Message.send("git reset --hard", location: url, response: response)
    }
    
    func pull(_ url: URL, response: @escaping ((String) -> Void)) {
        Message.send("git pull", location: url, response: response)
    }
    
    func push(_ url: URL, response: @escaping ((String) -> Void)) {
        Message.send("git push", location: url, response: response)
    }
    
    func listener(_: NSXPCListener, shouldAcceptNewConnection: NSXPCConnection) -> Bool {
        shouldAcceptNewConnection.exportedInterface = NSXPCInterface(with: Service.self)
        shouldAcceptNewConnection.exportedObject = self
        shouldAcceptNewConnection.resume()
        return true
    }
}
