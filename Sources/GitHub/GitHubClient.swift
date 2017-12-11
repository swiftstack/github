import HTTP

public class GitHubClient {
    static let baseUrl: String = "https://api.github.com"

    private let client: Client
    private let token: String?

    public init(token: String? = nil) throws {
        self.client = Client()
        self.token = token
    }

    func get<T: Decodable>(url: String) throws -> T {
        var request = Request(method: .get, url: try URL(url))
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        return try client.makeRequest(request)
    }

    func post<T: Encodable, U: Decodable>(path: String, object: T) throws -> U {
        let url = try URL(GitHubClient.baseUrl + path)
        var request = try Request(method: .post, url: url, body: object)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        return try client.makeRequest(request)
    }

    func put<T: Encodable, U: Decodable>(url: String, object: T) throws -> U {
        var request = try Request(method: .put, url: try URL(url), body: object)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        return try client.makeRequest(request)
    }
}
