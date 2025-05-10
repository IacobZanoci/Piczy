//
//  SignUpServiceProtocol.swift
//  SignUpDomain
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import NetworkClient

public protocol SignUpServiceProtocol {
    
    func signUp(
        request: SignUpRequest,
        completion: @escaping @Sendable (Result<SignUpResponse, NetworkError>) -> Void
    )
}
