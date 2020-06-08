import JSON
import HTTP

public class GitHubClient {
    private let client: Client
    private let token: String?

    public init(token: String? = nil) throws {
        self.client = Client(host: "api.github.com", port: 443)
        self.token = token
    }

    func makeRequest<T: Decodable>(_ request: Request) throws -> T {
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try client.makeRequest(request)
        return try JSON.decode(T.self, from: response.bytes ?? [])
    }

    func get<T: Decodable>(path: String) throws -> T {
        return try makeRequest(Request(url: URL(path), method: .get))
    }

    func post<T: Encodable, U: Decodable>(path: String, object: T) throws -> U {
        let request = try Request(url: URL(path), method: .post, body: object)
        return try makeRequest(request)
    }

    func put<T: Encodable, U: Decodable>(url: String, object: T) throws -> U {
        let request = try Request(url: URL(url), method: .put, body: object)
        return try makeRequest(request)
    }
}
