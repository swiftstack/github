import Test
import Async
import AsyncDispatch
import Foundation
@testable import GitHub

class ClientTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func testGetPullRequest() {
        async.task {
            do {
                let github = GitHubApi(client: try GitHubClient())
                let url = "https://api.github.com/repos/apple/swift/pulls/1"
                let pullRequest = try github.pullRequest.get(url)
                assertEqual(pullRequest.url, url)
                assertNotNil(pullRequest.mergeCommitSHA)
            } catch {
                fail(String(describing: error))
            }
            async.loop.terminate()
        }
        async.loop.run()
    }
}
