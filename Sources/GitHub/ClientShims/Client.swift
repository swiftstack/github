import Async
import HTTP
import JSON

import class Foundation.URLSession
import struct Foundation.URLRequest
import class Foundation.URLResponse
import struct Foundation.Data
import struct Foundation.Date
import struct Dispatch.DispatchQoS
import class Foundation.HTTPURLResponse

//------------------------------------------------------------------------------
// This is just a wrapper around URLSession until we have TLS in our HTTP.Client
//------------------------------------------------------------------------------

enum ClientError: Error {
    case invalidMimeType
    case notOk(status: Int, message: String)
    case dataIsNil
    case invalidJSON
    case invalidUrl
}

class Client {
    func makeRequest<T: Decodable>(_ request: Request) throws -> T {
        let urlRequest = try URLRequest(from: request)
        let (data, response) = try makeRequest(urlRequest)

        guard let mimeType = response.mimeType,
            mimeType == "application/json" else {
                throw ClientError.invalidMimeType
        }
        guard let jsonData = data else {
            throw ClientError.dataIsNil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: [UInt8](jsonData))
    }

    private func makeRequest(
        _ request: URLRequest
    ) throws -> (Data?, HTTPURLResponse) {
        let (data, _response) = try async.syncTask {
            return try URLSession.sendSynchronousRequest(request)
        }
        guard let response = _response else {
            throw URLSessionError.nilResponse
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLSessionError.notHTTPResponse
        }

        guard httpResponse.statusCode == 200 ||
            httpResponse.statusCode == 201 else {
                throw ClientError.notOk(
                    status: httpResponse.statusCode,
                    message: String(dataOrEmpty: data))
        }
        return (data, httpResponse)
    }
}

extension String {
    init(dataOrEmpty data: Data?) {
        if let data = data {
            self = String(data: data, encoding: .utf8) ?? ""
        } else {
            self = ""
        }
    }
}
