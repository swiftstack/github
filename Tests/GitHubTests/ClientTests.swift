import Test
import Fiber
@testable import Async
@testable import GitHub

class ClientTests: TestCase {
    override func setUp() {
        async.setUp(Fiber.self)
    }

    func testGetPullRequest() {
        async.main {
            let github = GitHubApi(client: try GitHubClient())
            let url = "/repos/apple/swift/pulls/1"
            let pullRequest = try github.pullRequest.get(url)
            expect(pullRequest.url == "https://api.github.com\(url)")
            expect(pullRequest.mergeCommitSHA != nil)
        }
        async.loop.run()
    }
}
