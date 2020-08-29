import Test
import Async

@testable import GitHub

class ClientTests: TestCase {
    func testGetPullRequest() {
        async {
            scope {
                let github = GitHubApi(client: try GitHubClient())
                let url = "/repos/apple/swift/pulls/1"
                let pullRequest = try github.pullRequest.get(url)
                expect(pullRequest.url == "https://api.github.com\(url)")
                expect(pullRequest.mergeCommitSHA != nil)
            }
        }
        loop.run()
    }
}
