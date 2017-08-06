public struct PullRequest: Decodable {
    public let url: String
    public let mergeCommitSHA: String?
    public let head: Commit?
    public let base: Commit?

    public init(
        url: String,
        mergeCommitSHA: String? = nil,
        head: Commit? = nil,
        base: Commit? = nil
    ) {
        self.url = url
        self.mergeCommitSHA = mergeCommitSHA
        self.head = head
        self.base = base
    }

    enum CodingKeys: String, CodingKey {
        case url
        case mergeCommitSHA = "merge_commit_sha"
        case head
        case base
    }
}
