//
//  File.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import CredentialsValidator

final class MockCredentialsValidator: CredentialsValidatorProtocol {
    
    var emailValid: Bool
    var passwordValid: Bool
    var confirmPasswordValid: Bool
    
    init(
        shouldEmailBeValid: Bool = true,
        shouldPasswordBeValid: Bool = true,
        shouldConfirmPasswordBeValid: Bool = true
    ) {
        self.emailValid = shouldEmailBeValid
        self.passwordValid = shouldPasswordBeValid
        self.confirmPasswordValid = shouldConfirmPasswordBeValid
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return emailValid
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return passwordValid
    }
    
    func isConfirmPasswordValid(password: String, confirmPassword: String) -> Bool {
        return confirmPasswordValid
    }
}
