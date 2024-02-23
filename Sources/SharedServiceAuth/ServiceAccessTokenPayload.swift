//
//  ServiceAccessTokenPayload.swift
//
//
//  Created by Sergey Basin on 23.02.2024.
//

import Vapor
import JWT

public struct ServiceAccessTokenPayload: JWTPayload {
    public let serviceId: UUID
    public let serviceName: String
    public let expiration: ExpirationClaim
    public let issuedAt: IssuedAtClaim
    public let audience: AudienceClaim
    public let issuer: IssuerClaim

    init(
        serviceId: UUID,
        serviceName: String,
        issuedAt: Date,
        expirationAt: Date,
        issuer: String,
        audience: [String]
    ) {
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.issuer = IssuerClaim(value: issuer)
        self.audience = AudienceClaim(value: audience)
        self.expiration = ExpirationClaim(value: expirationAt)
        self.issuedAt = IssuedAtClaim(value: issuedAt)
    }

    public func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
