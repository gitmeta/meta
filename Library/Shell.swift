import Foundation

class Shell {
    @discardableResult class func message(_ string: String, location: URL? = nil) throws -> String {
        let process = Process()
        let pipe = Pipe()
        process.arguments = string.components(separatedBy: " ")
        process.standardOutput = pipe
        if #available(OSX 10.13, *) {
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.currentDirectoryURL = location ?? URL(fileURLWithPath: NSHomeDirectory())
            try process.run()
        } else {
            process.launchPath = "/usr/bin/env"
            process.currentDirectoryPath = location?.absoluteString ?? String()
            process.launch()
        }
        return {
            $0.last == "\n" ? String($0.dropLast()) : $0
        } (String(decoding: pipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self))
    }
    
    private init() { }
}
