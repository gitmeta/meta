import Foundation

let delegate = Bash()
NSXPCListener.service().delegate = delegate
NSXPCListener.service().resume()
