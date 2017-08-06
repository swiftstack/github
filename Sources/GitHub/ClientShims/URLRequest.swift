import HTTP
import Foundation

extension Foundation.URL {
    init(_ url: HTTP.URL) throws {
        guard let url = URL(string: url.absoluteString) else {
            throw ClientError.invalidUrl
        }
        self = url
    }
}

extension URLRequest {
    init(from request: Request) throws {
        var urlRequest = URLRequest(url: try URL(request.url))
        if let authorization = request.authorization,
            case .token(let token) = authorization {
            urlRequest.setValue(
                "token \(token)", forHTTPHeaderField: "Authorization")
        }

        if request.method == .post {
            urlRequest.httpMethod = "POST"
        } else if request.method == .put {
            urlRequest.httpMethod = "PUT"
        }

        if let body = request.rawBody {
            urlRequest.setValue(
                "application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = Data(body)
        }

        self = urlRequest
    }
}
