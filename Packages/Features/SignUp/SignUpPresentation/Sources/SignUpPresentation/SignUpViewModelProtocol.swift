//
//  SignUpViewModelProtocol.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

public protocol SignUpViewModelProtocol {
    
    // MARK: - Properties
    
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    
    var onSignUpSuccess: (() -> Void)? { get set }
    
    // MARK: - Methods
    
    func validateCredentials() -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}
