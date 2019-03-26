public struct Commit {
    public let oid: git_oid
    
    /// The OID of the commit's tree.
    public let tree: PointerTo<Tree>
    
    /// The OIDs of the commit's parents.
    public let parents: [PointerTo<Commit>]
    
    /// The author of the commit.
    public let author: Signature
    
    /// The committer of the commit.
    public let committer: Signature
    
    /// The full message of the commit.
    public let message: String
    
    /// Create an instance with a libgit2 `git_commit` object.
    public init(_ pointer: OpaquePointer) {
        oid = OID(git_object_id(pointer).pointee)
        message = String(validatingUTF8: git_commit_message(pointer))!
        author = Signature(git_commit_author(pointer).pointee)
        committer = Signature(git_commit_committer(pointer).pointee)
        tree = PointerTo(OID(git_commit_tree_id(pointer).pointee))
        
        self.parents = (0..<git_commit_parentcount(pointer)).map {
            return PointerTo(OID(git_commit_parent_id(pointer, $0).pointee))
        }
    }
}
