public struct MergeResult: Decodable {
    public let sha: String
    public let merged: Bool
    public let message: String
}
