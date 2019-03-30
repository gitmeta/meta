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
        case .invalidUser: return .local("Alert.invalidUser")
        case .invalidEmail: return .local("Alert.invalidEmail")
        case .invalidPassword: return .local("Alert.invalidPassword")
        case .invalidUrl: return .local("Alert.invalidUrl")
        case .failedClone: return .local("Alert.failedClone")
        case .failedPush: return .local("Alert.failedPush")
        case .noRemote: return .local("Alert.noRemote")
        case .noBranch: return .local("Alert.noBranch")
        case .unknown: return .local("Alert.unknown")
        }
    }
}
