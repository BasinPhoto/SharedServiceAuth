//
//  ServiceAccessTokenPayload.swift
//
//
//  Created by Sergey Basin on 23.02.2024.
//

import Vapor
import JWT

public struct ServiceAccessTokenPayload: JWTPayload, Authenticatable {
    public let serviceId: UUID
    public let expiration: ExpirationClaim
    public let issuedAt: IssuedAtClaim
    public let audience: AudienceClaim
    public let issuer: IssuerClaim

    public init(
        serviceId: UUID,
        issuedAt: Date,
        expirationAt: Date,
        issuer: String,
        audience: [String]
    ) {
        self.serviceId = serviceId
        self.issuer = IssuerClaim(value: issuer)
        self.audience = AudienceClaim(value: audience)
        self.expiration = ExpirationClaim(value: expirationAt)
        self.issuedAt = IssuedAtClaim(value: issuedAt)
    }

    public func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
