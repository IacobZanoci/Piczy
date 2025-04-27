//
//  SignUpViewModel.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

public final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Properties
    
    public var email: String = ""
    public var password: String = ""
    public var confirmPassword: String = ""
    
    public var onSignUpSuccess: (() -> Void)?
    
    // MARK: - Initialization
    
    public init(onSignUpSuccess: (() -> Void)? = nil) {
        self.onSignUpSuccess = onSignUpSuccess
    }
    
    // MARK: - Validation Methods
    
    public func validateCredentials() -> Bool {
        return isValidEmail(email) &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isValidFormat = email.range(of: pattern, options: .regularExpression) != nil
        return isValidFormat && email.count >= 5
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        let isValidPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return isValidPassword.count >= 5
    }
}
