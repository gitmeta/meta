import Foundation

public enum Exception: LocalizedError {
    case folderNotFound
    case fileAlreadyExists
    case fileNoExists
    case unknown
}
