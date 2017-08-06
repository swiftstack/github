public struct Repository: Decodable {
    public let name: String
    public let fullName: String
    public let cloneUrl: String

    public init(name: String, fullName: String, cloneUrl: String) {
        self.name = name
        self.fullName = fullName
        self.cloneUrl = cloneUrl
    }

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case cloneUrl = "clone_url"
    }
}
