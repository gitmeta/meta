import Foundation

public enum Exception: LocalizedError {
    case folderNotFound
    case fileAlreadyExists
    case fileNoExists
    case noRepository
    case noRemote
    case noBranch
    case alreadyRepository
    case invalidUser
    case invalidEmail
    case invalidPassword
    case invalidUrl
    case failedClone
    case failedPush
    case failedPull
    case failedReset
    case unsynched
    case unknown
}
