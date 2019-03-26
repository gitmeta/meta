import meta
import Foundation

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
        status.branch = branch(repository)
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
        let index = self.index(repository)
        let signature = self.signature(credentials)
        var tree = git_oid()
        git_index_write_tree(&tree, index)
        var parent = git_oid()
        git_reference_name_to_id(&parent, repository, "HEAD")
        var look: OpaquePointer?
        git_tree_lookup(&look, repository, &tree)
        var pretty = git_buf()
        git_message_prettify(&pretty, message, 0, 35)
        var history: OpaquePointer!
        git_commit_lookup(&history, repository, &parent)
        var id = git_oid()
        ContiguousArray(arrayLiteral: history).withUnsafeBufferPointer {
            git_commit_create(&id, repository, "HEAD", signature, signature, "UTF-8", pretty.ptr, look, 1,
                              UnsafeMutablePointer(mutating: $0.baseAddress))
            git_commit_free(history)
            git_buf_free(&pretty)
            git_tree_free(look)
            git_signature_free(signature)
            git_index_free(index)
        }
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
    
    private func name(_ status: git_status_entry) -> String {
        return {
            $0?.new_file.path.map(String.init(cString:)) ?? String()
        } (status.index_to_workdir?.pointee ?? status.head_to_index?.pointee)
    }
    
    private func signature(_ credentials: meta.Credentials) -> UnsafeMutablePointer<git_signature> {
        return {
            var signature: UnsafeMutablePointer<git_signature>!
            git_signature_new(&signature, credentials.name, credentials.email, git_time_t($0.timeIntervalSince1970),
                              Int32(TimeZone.current.secondsFromGMT(for: $0) / 60))
            return signature
        } (Date())
    }
}
