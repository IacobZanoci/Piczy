//
//  LoginServiceProtocol.swift
//  LoginDomain
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import NetworkClient

public protocol LoginServiceProtocol {
    
    func signIn(request: LoginRequest, completion: @escaping @Sendable (Result<LoginResponse, NetworkError>) -> Void)
}
