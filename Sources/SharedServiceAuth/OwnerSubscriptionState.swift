//
//  OwnerSubscriptionState.swift
//
//
//  Subscription state of a studio owner, exchanged between Studiosy-UMS
//  (producer, `GET /v1/internal/users/:userId/subscription`) and Studiosy-BE
//  (consumer, native booking entitlement check).
//
//  Both sides MUST use this type. It previously existed as two separate
//  structs whose coding keys had drifted apart, which made every entitlement
//  check fail with a decoding error.
//

import Vapor

public struct OwnerSubscriptionState: Content, Sendable, Equatable {
    public let userID: UUID
    public let isPremium: Bool
    /// Raw value of the subscription plan, `nil` when the owner has no plan.
    public let plan: String?
    public let validUntil: Date?

    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isPremium = "is_premium"
        case plan
        case validUntil = "valid_until"
    }

    public init(
        userID: UUID,
        isPremium: Bool,
        plan: String? = nil,
        validUntil: Date? = nil
    ) {
        self.userID = userID
        self.isPremium = isPremium
        self.plan = plan
        self.validUntil = validUntil
    }
}
