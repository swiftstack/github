import HTTP

public class GitHubClient {
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

    func post<T: Encodable, U: Decodable>(url: String, json: T) throws -> U {
        var request = try Request(method: .post, url: try URL(url), json: json)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        return try client.makeRequest(request)
    }

    func put<T: Encodable, U: Decodable>(url: String, json: T) throws -> U {
        var request = try Request(method: .put, url: try URL(url), json: json)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        return try client.makeRequest(request)
    }
}
