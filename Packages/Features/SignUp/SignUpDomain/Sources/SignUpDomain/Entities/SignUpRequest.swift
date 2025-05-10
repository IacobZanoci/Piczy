//
//  SignUpRequest.swift
//  SignUpDomain
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation

public struct SignUpRequest: Codable {
    
    public let email: String
    public let password: String
    public let confirmPassword: String
    
    public init(
        email: String,
        password: String,
        confirmPassword: String
    ) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
