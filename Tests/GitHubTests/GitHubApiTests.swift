import Test
@testable import GitHub

class GitHubApiTests: TestCase {
    func testUpdateStatus() {
        let status = GitHubApi.StatusApi.UpdateStatus(
            state: "state",
            targetUrl: "url",
            description: "description",
            context: "context")

        let encoder = TestEncoder()
        assertNoThrow(try status.encode(to: encoder))

        let expected = ["state", "target_url", "description", "context"]
        assertEqual(encoder.keys, expected)
    }
}

class TestKeyedContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] { return [] }

    let encoder: TestEncoder

    init(encoder: TestEncoder) {
        self.encoder = encoder
    }

    func encodeNil(forKey key: K) throws {}

    func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        encoder.keys.append(key.stringValue)
    }

    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: K
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        fatalError()
    }

    func superEncoder() -> Encoder {
        fatalError()
    }

    func superEncoder(forKey key: K) -> Encoder {
        fatalError()
    }
}

class TestEncoder: Encoder {
    var codingPath: [CodingKey] { return [] }
    var userInfo: [CodingUserInfoKey : Any] { return [:] }

    var keys = [String]()

    func container<Key>(
        keyedBy type: Key.Type
    ) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(TestKeyedContainer<Key>(encoder: self))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
}
