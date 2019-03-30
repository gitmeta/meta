import Foundation

public enum Exception: LocalizedError {
    case folderNotFound
    case fileAlreadyExists
    case fileNoExists
    case noRepository
    case alreadyRepository
    case invalidUser
    case invalidEmail
    case invalidPassword
    case invalidUrl
    case failedClone
    case noRemote
    case unknown
}
