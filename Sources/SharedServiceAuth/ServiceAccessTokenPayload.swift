//
//  ServiceAccessTokenPayload.swift
//
//
//  Created by Sergey Basin on 23.02.2024.
//

import Vapor
import JWT

struct ServiceAccessTokenPayload: JWTPayload {
    let serviceId: UUID
    let serviceName: String
    let expiration: ExpirationClaim
    let issuedAt: IssuedAtClaim
    let audience: AudienceClaim
    let issuer: IssuerClaim

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

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
