import meta
import Foundation

class Libgit: meta.Libgit {
    override init() {
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
    
    override func status(_ repository: OpaquePointer!) -> String {
        var list: OpaquePointer?
        git_status_list_new(&list, repository, nil)
        let result = (0 ..< git_status_list_entrycount(list)).reduce(into: .local("Git.branch") + branch(repository)) {
            $0 += {
                var status = "\n"
                switch $0.pointee.status {
                case GIT_STATUS_WT_MODIFIED, GIT_STATUS_INDEX_MODIFIED: status += .local("Git.modified")
                case GIT_STATUS_WT_NEW: status += .local("Git.untracked")
                case GIT_STATUS_INDEX_NEW: status += .local("Git.added")
                case GIT_STATUS_WT_DELETED, GIT_STATUS_INDEX_DELETED: status += .local("Git.deleted")
                default: return String()
                }
                return status + name($0.pointee)
            } (git_status_byindex(list, $1)!)
        }
        git_status_list_free(list)
        return result
    }
    
    private func branch(_ repository: OpaquePointer) -> String {
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
        return name
    }
    
    private func name(_ status: git_status_entry) -> String {
        return {
            $0?.new_file.path.map(String.init(cString:)) ?? String()
        } (status.index_to_workdir?.pointee ?? status.head_to_index?.pointee)
    }
}
