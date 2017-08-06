public struct Comment: Decodable {
    public let issueUrl: String
    public let user: User
    public let body: String

    enum CodingKeys: String, CodingKey {
        case issueUrl = "issue_url"
        case user
        case body
    }

    public init(issueUrl: String, user: User, body: String) {
        self.issueUrl = issueUrl
        self.user = user
        self.body = body
    }
}
