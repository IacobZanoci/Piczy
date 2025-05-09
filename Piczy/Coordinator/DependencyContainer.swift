//
//  DependencyContainer.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import CredentialsValidator

@MainActor
final class DependencyContainer {
    
    // MARK: - Shared instances
    
    /// Shared instance of `CredentialsValidator` used for validating user credentials.
    lazy var credentialsValidator = CredentialsValidator()
}
