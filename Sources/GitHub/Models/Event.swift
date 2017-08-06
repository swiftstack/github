public struct Event: Decodable {
    public let action: String
    public let issue: Issue
    public let comment: Comment
    public let repository: Repository

    public init(
        action: String,
        issue: Issue,
        comment: Comment,
        repository: Repository
    ) {
        self.action = action
        self.issue = issue
        self.comment = comment
        self.repository = repository
    }
}
