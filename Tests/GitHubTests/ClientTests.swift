import Test
import Async
import AsyncDispatch
import Foundation
@testable import GitHub

class ClientTests: TestCase {
    override func setUp() {
        async.use(Dispatch.self)
    }

    func testGetPullRequest() {
        async.task {
            do {
                let github = GitHubApi(client: try GitHubClient())
                let url = "/repos/apple/swift/pulls/1"
                let pullRequest = try github.pullRequest.get(url)
                assertEqual(pullRequest.url, "https://api.github.com\(url)")
                assertNotNil(pullRequest.mergeCommitSHA)
            } catch {
                fail(String(describing: error))
            }
            async.loop.terminate()
        }
        async.loop.run()
    }
}
