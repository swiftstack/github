enum ApiError: Error {
    case commitRepositoryIsNil
    case invalidSetStatusResult
}

public struct GitHubApi {
    public let pullRequest: PullRequestApi
    public let status: StatusApi

    static let baseURL = "https://api.github.com"

    public init(client: GitHubClient) {
        self.pullRequest = PullRequestApi(client: client)
        self.status = StatusApi(client: client)
    }

    public struct PullRequestApi {
        let client: GitHubClient
        init(client: GitHubClient) {
            self.client = client
        }

        public func get(_ path: String) async throws -> PullRequest {
            return try await client.get(path: path)
        }

        public func merge(_ pullRequest: PullRequest) async throws -> MergeResult {
            let url = pullRequest.url.appending("/merge")
            var json = [String : String]()
            if let head = pullRequest.head {
                json["sha"] = head.sha
            }
            return try await client.put(url: url, object: json)
        }
    }

    public struct StatusApi {
        public enum Status: String {
            case pending
            case success
            case error
            case failure
        }

        public struct StatusInfo {
            let description: String
            let targetUrl: String
            let context: String

            public init(description: String, targetUrl: String, context: String) {
                self.description = description
                self.targetUrl = targetUrl
                self.context = context
            }
        }

        let client: GitHubClient
        init(client: GitHubClient) {
            self.client = client
        }

        struct UpdateStatus: Encodable {
            let state: String
            let targetUrl: String
            let description: String
            let context: String

            enum CodingKeys: String, CodingKey {
                case state
                case targetUrl = "target_url"
                case description
                case context
            }
        }

        public func set(_ status: Status, info: StatusInfo, for commit: Commit) async throws {
            guard let name = commit.repo?.fullName else {
                throw ApiError.commitRepositoryIsNil
            }
            let path = "/repos/\(name)/statuses/\(commit.sha)"
            let updateStatus = UpdateStatus(
                state: status.rawValue,
                targetUrl: info.targetUrl,
                description: info.description,
                context: info.context)

            let result: State = try await client.post(path: path, object: updateStatus)
            guard result.state == status.rawValue else {
                throw ApiError.invalidSetStatusResult
            }
        }
    }
}
