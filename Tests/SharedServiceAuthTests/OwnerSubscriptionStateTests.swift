import XCTest
@testable import SharedServiceAuth

final class OwnerSubscriptionStateTests: XCTestCase {
    /// Vapor's default JSON coders, which is what UMS encodes with and BE decodes with.
    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    /// Pins the wire format. UMS produces this JSON and BE consumes it, so a
    /// rename on either side must break here rather than in production.
    func testDecodesSnakeCasePayload() throws {
        let json = """
        {
          "user_id": "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7",
          "is_premium": true,
          "plan": "studio",
          "valid_until": "2026-09-08T00:00:00Z"
        }
        """.data(using: .utf8)!

        let state = try makeDecoder().decode(OwnerSubscriptionState.self, from: json)

        XCTAssertEqual(state.userID, UUID(uuidString: "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7"))
        XCTAssertTrue(state.isPremium)
        XCTAssertEqual(state.plan, "studio")
        XCTAssertNotNil(state.validUntil)
    }

    func testDecodesPayloadWithoutOptionalFields() throws {
        let json = """
        { "user_id": "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7", "is_premium": false }
        """.data(using: .utf8)!

        let state = try makeDecoder().decode(OwnerSubscriptionState.self, from: json)

        XCTAssertFalse(state.isPremium)
        XCTAssertNil(state.plan)
        XCTAssertNil(state.validUntil)
    }

    func testEncodesSnakeCaseKeys() throws {
        let state = OwnerSubscriptionState(
            userID: UUID(uuidString: "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7")!,
            isPremium: true,
            plan: "unlimited",
            validUntil: Date(timeIntervalSince1970: 1_757_289_600)
        )

        let data = try makeEncoder().encode(state)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])

        XCTAssertEqual(Set(object.keys), ["user_id", "is_premium", "plan", "valid_until"])
    }

    func testRoundTripsThroughTheWireFormat() throws {
        let state = OwnerSubscriptionState(
            userID: UUID(uuidString: "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7")!,
            isPremium: true,
            plan: "studio",
            validUntil: Date(timeIntervalSince1970: 1_757_289_600)
        )

        let decoded = try makeDecoder().decode(
            OwnerSubscriptionState.self,
            from: try makeEncoder().encode(state)
        )

        XCTAssertEqual(decoded, state)
    }
}

final class StudiosyServiceIdentityTests: XCTestCase {
    /// Pins the value: it is compared across two services, so a change here is
    /// a wire-compatibility change, not a refactor.
    func testBackendIdentifierIsStable() {
        XCTAssertEqual(
            StudiosyServiceIdentity.backend.uuidString,
            "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7"
        )
    }

    func testBackendIsRecognized() {
        XCTAssertTrue(StudiosyServiceIdentity.recognized.contains(StudiosyServiceIdentity.backend))
    }
}
