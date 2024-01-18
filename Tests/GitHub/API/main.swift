import Test
import JSON

@testable import GitHub

test("UpdateStatus") {
    let status = GitHubApi.StatusApi.UpdateStatus(
        state: "1",
        targetUrl: "2",
        description: "3",
        context: "4")

    let bytes = try JSON.encode(status)
    let string = String(decoding: bytes, as: UTF8.self)
    let expected =
        #"{"state":"1","target_url":"2","# +
        #""description":"3","context":"4"}"#
    expect(string == expected)
}

await run()
