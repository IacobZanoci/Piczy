//
//  DependencyContainer.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import LoginDomain
import NetworkClient
import CredentialsValidator

@MainActor
final class DependencyContainer {
    
    // MARK: - Shared instances
    
    /// Shared instance of `CredentialsValidator` used for validating user credentials.
    lazy var credentialsValidator = CredentialsValidator()
    
    /// Shared instance of `NetworkClient` used for API requests.
    lazy var networkClient = NetworkClient()
    
    /// Shared instance of `MockLoginService` used for mocking network requests.
    lazy var loginService = MockLoginService(networkClient: networkClient)
}
