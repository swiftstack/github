public struct User: Decodable {
    public let login: String

    public init(login: String) {
        self.login = login
    }
}
