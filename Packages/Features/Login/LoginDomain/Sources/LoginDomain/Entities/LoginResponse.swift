//
//  LoginResponse.swift
//  LoginDomain
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

public struct LoginResponse: Decodable, Sendable {
    
    public let token: String
}
