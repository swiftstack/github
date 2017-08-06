public struct Issue: Decodable {
    public let pullRequest: PullRequest

    public init(pullRequest: PullRequest) {
        self.pullRequest = pullRequest
    }

    enum CodingKeys: String, CodingKey {
        case pullRequest = "pull_request"
    }
}
