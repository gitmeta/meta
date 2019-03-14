import Foundation

class Message {
    class func send(_ string: String, location: URL, response: @escaping((String) -> Void)) {
        let process = Process()
        let pipe = Pipe()
        process.arguments = string.components(separatedBy: " ")
        process.standardOutput = pipe
        process.standardError = pipe
        if #available(OSX 10.13, *) {
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.currentDirectoryURL = location
            do {
                try process.run()
            } catch {
                response(error.localizedDescription)
                return
            }
        } else {
            process.launchPath = "/usr/bin/env"
            process.currentDirectoryPath = location.path
            process.launch()
        }
        process.waitUntilExit()
        response({
            $0.last == "\n" ? String($0.dropLast()) : $0
        } (String(decoding: pipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)))
    }
    
    private init() { }
}
