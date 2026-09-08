//
//  StudiosyServiceIdentity.swift
//
//
//  Identifiers that services present to one another inside service access
//  tokens.
//

import Foundation

public enum StudiosyServiceIdentity {
    /// Identifier the Studiosy backend puts in `ServiceAccessTokenPayload.serviceId`.
    ///
    /// Compiled in rather than read from the environment on purpose. It is not a
    /// secret — it travels inside a token whose signature already proves the
    /// caller holds the shared key pair, and anyone able to forge that signature
    /// could put any value here. Keeping it in two independently managed
    /// deployment blobs, under two different variable names, only created a way
    /// for the two sides to drift apart silently, which is exactly what happened
    /// on dev: one character transposed, and every service-to-service call was
    /// rejected as `unidentified_service`.
    public static let backend = UUID(uuidString: "DCC91E8E-9841-4CC0-A0DA-4DB4E7C7FEF7")!

    /// Every identifier UMS accepts on its internal endpoints.
    public static let recognized: Set<UUID> = [backend]
}
