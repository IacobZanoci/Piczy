//
//  LoginRequest.swift
//  LoginDomain
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

public struct LoginRequest: Encodable, Sendable {
    
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
