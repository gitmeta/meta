import meta
import Foundation

private class Wrapper<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

public enum Credentialis {
    case `default`
    case sshAgent
    case plaintext(username: String, password: String)
    case sshMemory(username: String, publicKey: String, privateKey: String, passphrase: String)
    
    internal static func fromPointer(_ pointer: UnsafeMutableRawPointer) -> Credentialis {
        return Unmanaged<Wrapper<Credentialis>>.fromOpaque(UnsafeRawPointer(pointer)).takeRetainedValue().value
    }
    
    internal func toPointer() -> UnsafeMutableRawPointer {
        return Unmanaged.passRetained(Wrapper(self)).toOpaque()
    }
}

/// Handle the request of credentials, passing through to a wrapped block after converting the arguments.
/// Converts the result to the correct error code required by libgit2 (0 = success, 1 = rejected setting creds,
/// -1 = error)
internal func credentialsCallback(
    cred: UnsafeMutablePointer<UnsafeMutablePointer<git_cred>?>?,
    url: UnsafePointer<CChar>?,
    username: UnsafePointer<CChar>?,
    _: UInt32,
    payload: UnsafeMutableRawPointer? ) -> Int32 {
    
    let result: Int32
    
    // Find username_from_url
//    let name = username.map(String.init(cString:))
    
    result = git_cred_userpass_plaintext_new(cred, "vauxhall", "")
    print(result)
    /*switch Credentialis.fromPointer(payload!) {
    case .default:
        result = git_cred_default_new(cred)
    case .sshAgent:
        result = git_cred_ssh_key_from_agent(cred, name!)
    case .plaintext(let username, let password):
        result = git_cred_userpass_plaintext_new(cred, username, password)
    case .sshMemory(let username, let publicKey, let privateKey, let passphrase):
        result = git_cred_ssh_key_memory_new(cred, username, publicKey, privateKey, passphrase)
    }*/
    
    return (result != GIT_OK.rawValue) ? -1 : 0
}

class Libgit: meta.Libgit {
    override init() {
        super.init()
        git_libgit2_init()
    }
    
    override func repository(_ url: URL) -> OpaquePointer? {
        var repository: OpaquePointer?
        git_repository_open_ext(&repository, url.path, GIT_REPOSITORY_OPEN_NO_SEARCH.rawValue, nil)
        return repository
    }
    
    override func release(repository: OpaquePointer!) {
        git_repository_free(repository)
    }
    
    override func clone(_ url: URL, path: URL) throws -> OpaquePointer! {
        let pointer = UnsafeMutablePointer<git_clone_options>.allocate(capacity: 1)
        git_clone_init_options(pointer, UInt32(GIT_CLONE_OPTIONS_VERSION))
        var options = pointer.move()
        pointer.deallocate()
        options.bare = 0

        options.checkout_opts = {
            let pointer = UnsafeMutablePointer<git_checkout_options>.allocate(capacity: 1)
            git_checkout_init_options(pointer, UInt32(GIT_CHECKOUT_OPTIONS_VERSION))
            var options = pointer.move()
            pointer.deallocate()
            options.checkout_strategy = GIT_CHECKOUT_SAFE.rawValue
            return options
        } ()
        
        options.fetch_opts = {
            let pointer = UnsafeMutablePointer<git_fetch_options>.allocate(capacity: 1)
            git_fetch_init_options(pointer, UInt32(GIT_FETCH_OPTIONS_VERSION))
            let fetch = pointer.move()
            pointer.deallocate()
            return fetch
        } ()
        
        var repository: OpaquePointer!
        let result = git_clone(&repository, url.absoluteString, path.withUnsafeFileSystemRepresentation({ $0 }), &options)
        if result != GIT_OK.rawValue { throw Exception.failedClone }
        return repository
    }
    
    override func create(_ url: URL) -> OpaquePointer! {
        var repository: OpaquePointer?
        git_repository_init(&repository, url.path, 0)
        return repository
    }
    
    override func status(_ repository: OpaquePointer!) -> Status {
        var list: OpaquePointer?
        git_status_list_new(&list, repository, nil)
        var status = (0 ..< git_status_list_entrycount(list)).map({ git_status_byindex(list, $0)! }).reduce(into: Status()) {
            switch $1.pointee.status {
            case GIT_STATUS_WT_MODIFIED, GIT_STATUS_INDEX_MODIFIED: $0.modified.append(name($1.pointee))
            case GIT_STATUS_WT_NEW: $0.untracked.append(name($1.pointee))
            case GIT_STATUS_INDEX_NEW: $0.added.append(name($1.pointee))
            case GIT_STATUS_WT_DELETED, GIT_STATUS_INDEX_DELETED: $0.deleted.append(name($1.pointee))
            default: break
            }
        }
        git_status_list_free(list)
        status.remote = remote(repository)?.absoluteString ?? status.remote
        status.branch = branch(repository)
        status.commit = commit(repository).description
        return status
    }
    
    override func add(_ repository: OpaquePointer!, file: String) {
        var file = UnsafeMutablePointer<Int8>(mutating: (file as NSString).utf8String)
        var paths = git_strarray(strings: &file, count: 1)
        let index = self.index(repository)
        git_index_add_all(index, &paths, 0, nil, nil)
        git_index_write(index)
        git_index_free(index)
    }
    
    override func commit(_ message: String, credentials: meta.Credentials, repository: OpaquePointer!) {
        var id = git_oid()
        let index = self.index(repository)
        let signature = self.signature(credentials)
        var tree = git_oid()
        git_index_write_tree(&tree, index)
        var parent = git_oid()
        git_reference_name_to_id(&parent, repository, "HEAD")
        var look: OpaquePointer!
        git_tree_lookup(&look, repository, &tree)
        var pretty = git_buf()
        git_message_prettify(&pretty, message, 0, 0)
        var history: OpaquePointer!
        git_commit_lookup(&history, repository, &parent)
        let list = ContiguousArray([history])
        
        git_commit_create(&id, repository, "HEAD", signature, signature, "UTF-8", pretty.ptr, look, history == nil ? 0 : 1,
                          list.withUnsafeBufferPointer { UnsafeMutablePointer(mutating: $0.baseAddress) })
        
        git_commit_free(history)
        git_buf_free(&pretty)
        git_tree_free(look)
        git_signature_free(signature)
        git_index_free(index)
    }
    
    override func history(_ repository: OpaquePointer!) -> [meta.Commit] {
        var id = git_oid()
        var walker: OpaquePointer?
        git_reference_name_to_id(&id, repository, "HEAD")
        git_revwalk_new(&walker, repository)
        git_revwalk_sorting(walker, GIT_SORT_TOPOLOGICAL.rawValue)
        git_revwalk_sorting(walker, GIT_SORT_TIME.rawValue)
        git_revwalk_push(walker, &id)
        var result = [meta.Commit]()
        while(git_revwalk_next(&id, walker) == GIT_OK.rawValue) { result.append(commit(id, repository: repository)) }
        return result
    }
    
    override func push(_ repository: OpaquePointer!) throws {
        var remote: OpaquePointer!
        git_remote_lookup(&remote, repository, "origin")
        if remote == nil {
            throw Exception.noRemote
        } else {
            //        let cred = Credentialis.default
            let calls = UnsafeMutablePointer<git_remote_callbacks>.allocate(capacity: 1)
            git_remote_init_callbacks(calls, UInt32(GIT_REMOTE_CALLBACKS_VERSION))
            var callback = calls.move()
            //        callback.payload = cred.toPointer()
            callback.credentials = credentialsCallback
            calls.deallocate()
            
            
            print(git_remote_connect(remote, GIT_DIRECTION_PUSH, &callback, nil, nil))
            print(git_remote_add_push(remote, "origin", "refs/heads/master:refs/heads/master"))
            
            let pointer = UnsafeMutablePointer<git_push_options>.allocate(capacity: 1)
            git_push_init_options(pointer, UInt32(GIT_PUSH_OPTIONS_VERSION))
            var options = pointer.move()
            pointer.deallocate()
            
            print(git_remote_upload(remote, nil, &options))
            git_remote_free(remote)
        }
    }
    
    override func remote(_ repository: OpaquePointer!) -> URL? {
        var url: URL?
        var remote: OpaquePointer!
        git_remote_lookup(&remote, repository, "origin")
        if let remote = remote,
            let string = String(validatingUTF8: git_remote_url(remote)) {
            url = URL(string: string)
        }
        git_remote_free(remote)
        return url
    }
    
    private func index(_ repository: OpaquePointer) -> OpaquePointer {
        var index: OpaquePointer?
        git_repository_index(&index, repository)
        return index!
    }
    
    private func branch(_ repository: OpaquePointer) -> String {
        if git_repository_head_unborn(repository) == 1 {
            return .local("Git.unborn")
        } else {
            var head: OpaquePointer?
            git_repository_head(&head, repository)
            let name: String
            if git_reference_is_branch(head) != 0 || git_reference_is_remote(head) != 0 {
                var pointer: UnsafePointer<Int8>?
                git_branch_name(&pointer, head)
                name = String(validatingUTF8: pointer!)!
            } else if git_reference_is_tag(head) != 0 {
                name = String(validatingUTF8: git_reference_name(head))!.components(separatedBy: "/").last!
            } else {
                name = String(validatingUTF8: git_reference_shorthand(head))!
            }
            git_reference_free(head)
            return .local("Git.branch") + name
        }
    }
    
    private func commit(_ repository: OpaquePointer) -> meta.Commit {
        var id = git_oid()
        git_reference_name_to_id(&id, repository, "HEAD")
        return commit(id, repository: repository)
    }
    
    private func commit(_ id: git_oid, repository: OpaquePointer) -> meta.Commit {
        var result = meta.Commit()
        var id = id
        var commit: OpaquePointer!
        git_commit_lookup(&commit, repository, &id)
        if commit != nil {
            result.id = self.id(id)
            result.author = String(validatingUTF8: git_commit_author(commit).pointee.name) ?? result.author
            result.message = String(validatingUTF8: git_commit_message(commit))!
            result.date = Date(timeIntervalSince1970: TimeInterval(git_commit_author(commit).pointee.when.time))
            git_commit_free(commit)
        }
        return result
    }
    
    private func name(_ status: git_status_entry) -> String {
        return {
            $0?.new_file.path.map(String.init(cString:)) ?? String()
        } (status.index_to_workdir?.pointee ?? status.head_to_index?.pointee)
    }
    
    private func signature(_ credentials: meta.Credentials) -> UnsafeMutablePointer<git_signature> {
        return {
            var signature: UnsafeMutablePointer<git_signature>!
            git_signature_new(&signature, credentials.user, credentials.email, git_time_t($0.timeIntervalSince1970),
                              Int32(TimeZone.current.secondsFromGMT(for: $0) / 60))
            return signature
        } (Date())
    }
    
    private func id(_ oid: git_oid) -> String {
        let length = Int(GIT_OID_RAWSZ) * 2
        let string = UnsafeMutablePointer<Int8>.allocate(capacity: length)
        var oid = oid
        git_oid_fmt(string, &oid)
        return String(bytesNoCopy: string, length: length, encoding: .ascii, freeWhenDone: true)!
    }
}
