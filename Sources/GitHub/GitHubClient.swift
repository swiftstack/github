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

    func get<T: Decodable>(url: String) throws -> T {
        var request = Request(method: .get, url: try URL(url))
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try client.makeRequest(request)
        return try JSON.decode(T.self, from: response.rawBody ?? [])
    }

    func post<T: Encodable, U: Decodable>(path: String, object: T) throws -> U {
        let url = try URL(path)
        var request = try Request(method: .post, url: url, body: object)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try client.makeRequest(request)
        return try JSON.decode(U.self, from: response.rawBody ?? [])
    }

    func put<T: Encodable, U: Decodable>(url: String, object: T) throws -> U {
        var request = try Request(method: .put, url: try URL(url), body: object)
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try client.makeRequest(request)
        return try JSON.decode(U.self, from: response.rawBody ?? [])
    }
}
