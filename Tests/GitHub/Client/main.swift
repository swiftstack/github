import Test
import Event

@testable import GitHub

test("GetPullRequest") {
    Task {
        do {
            let github = GitHubApi(client: try GitHubClient())
        let url = "/repos/apple/swift/pulls/1"
        let pullRequest = try await github.pullRequest.get(url)

        expect(pullRequest.url == "https://api.github.com\(url)")

        expect(
            pullRequest.mergeCommitSHA
            ==
            "24643eb0ad928308bf1784ec46fe9288b414e8a5"
        )

            await loop.terminate()
        } catch {
            fail(String(describing: error))
        }
    }

    await loop.run()
}

await run()
