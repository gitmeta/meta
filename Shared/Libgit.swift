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
        
        return unsafeIndex().flatMap { index in
            defer { git_index_free(index) }
            let addResult = git_index_add_all(index, &paths, 0, nil, nil)
            guard addResult == GIT_OK.rawValue else {
                return .failure(NSError(gitError: addResult, pointOfFailure: "git_index_add_all"))
            }
            // write index to disk
            let writeResult = git_index_write(index)
            guard writeResult == GIT_OK.rawValue else {
                return .failure(NSError(gitError: writeResult, pointOfFailure: "git_index_write"))
            }
            return .success(())
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
}
