import Dispatch
import Foundation

enum URLSessionError: Error {
    case nilResponse
    case notHTTPResponse
}

extension URLSession {
    typealias DataTaskResult = (Data?, URLResponse?, Error?)

    /// wrapper around URLSession, throws on error
    static func sendSynchronousRequest(
        _ request: URLRequest
    ) throws -> (Data?, URLResponse?) {
        let session = URLSession(configuration: .default)
        let (data, response, error) = session.dataTaskResult(for: request)
        if let error = error {
            throw error
        }
        session.finishTasksAndInvalidate()
        return (data, response)
    }

    /// synchronous version of dataTask
    func dataTaskResult(for request: URLRequest) -> DataTaskResult {
        var data: Data? = nil
        var response: URLResponse? = nil
        var error: Error? = nil

        let semaphore = DispatchSemaphore(value: 0)

        self.dataTask(
            with: request,
            completionHandler: { (_data, _response, _error) in
                data = _data
                response = _response
                error = _error
                semaphore.signal()
        }).resume()

        semaphore.wait()

        return (data, response, error)
    }
}
