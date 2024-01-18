import JSON
import HTTP

public class GitHubClient {
    private let client: Client
    private let token: String?

    public init(token: String? = nil) throws {
        self.client = Client(url: GitHubApi.baseURL)!
        self.token = token
    }

    func makeRequest<T: Decodable>(_ request: Request) async throws -> T {
        if let token = token {
            request.authorization = .token(credentials: token)
        }
        let response = try await client.makeRequest(request)
        guard case .input(let stream) = response.body else {
            throw Error.invalidResponse
        }
        return try await JSON.decode(T.self, from: stream)
    }

    func get<T: Decodable>(path: String) async throws -> T {
        return try await makeRequest(Request(url: URL(path), method: .get))
    }

    func post<T: Encodable, U: Decodable>(
        path: String,
        object: T
    ) async throws -> U {
        let request = try Request(url: URL(path), method: .post, body: object)
        return try await makeRequest(request)
    }

    func put<T: Encodable, U: Decodable>(
        url: String,
        object: T
    ) async throws -> U {
        let request = try Request(url: URL(url), method: .put, body: object)
        return try await makeRequest(request)
    }
}
