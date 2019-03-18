import meta
import Foundation

extension String {
    static func local(_ key: String) -> String { return NSLocalizedString(key, comment: String()) }
}

extension Exception {
    var local: String {
        switch self {
        case .fileAlreadyExists: return .local("Alert.fileAlreadyExists")
        case .folderNotFound: return .local("Alert.folderNotFound")
        case .fileNoExists: return .local("Alert.fileNoExists")
        case .noRepository: return .local("Alert.noRepository")
        case .alreadyRepository: return .local("Alert.alreadyRepository")
        case .unknown: return .local("Alert.unknown")
        }
    }
}
