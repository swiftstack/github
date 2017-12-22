import JSON
import HTTP
import Client

public class GitHubClient {
    // static let baseUrl: String = "https://api.github.com"
    let proxyHost = "127.0.0.1"
    let proxyPort = 6543

    private let client: Client
    private let token: String?

    public init(token: String? = nil) throws {
        self.client = Client(host: proxyHost, port: proxyPort)
        self.token = token
    }

    func makeRequest<T: Decodable>(_ request: Request) throws -> T {
        var request = request
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try client.makeRequest(request)
        return try JSON.decode(T.self, from: response.rawBody ?? [])
    }

    func get<T: Decodable>(path: String) throws -> T {
        return try makeRequest(Request(method: .get, url: URL(path)))

    }

    func post<T: Encodable, U: Decodable>(path: String, object: T) throws -> U {
        let request = try Request(method: .post, url: URL(path), body: object)
        return try makeRequest(request)
    }

    func put<T: Encodable, U: Decodable>(url: String, object: T) throws -> U {
        let request = try Request(method: .put, url: URL(url), body: object)
        return try makeRequest(request)
    }
}
