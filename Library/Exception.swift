import Foundation

public enum Exception: LocalizedError {
    case folderNotFound
    case fileAlreadyExists
    case fileNoExists
    case noRepository
    case alreadyRepository
    case invalidName
    case invalidEmail
    case failedClone
    case unknown
}
