import Foundation

@objc protocol Shell {
    func hello(_ done: @escaping((String) -> Void))
}

class Bash: NSObject, NSXPCListenerDelegate, Shell {
    func listener(_: NSXPCListener, shouldAcceptNewConnection: NSXPCConnection) -> Bool {
        /*let exportedObject = MyService()
        newConnection.exportedInterface = NSXPCInterface(with: MyServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()*/
        shouldAcceptNewConnection.exportedInterface = NSXPCInterface(with: Shell.self)
        shouldAcceptNewConnection.exportedObject = self
        shouldAcceptNewConnection.resume()
        return true
    }
    
    func hello(_ done: @escaping((String) -> Void)) {
        done("World")
    }
}
