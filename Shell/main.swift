import Foundation

let listener = Shell()
NSXPCListener.service().delegate = listener
NSXPCListener.service().resume()
