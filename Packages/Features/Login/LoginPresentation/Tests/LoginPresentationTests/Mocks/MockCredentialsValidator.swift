//
//  MockCredentialsValidator.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import CredentialsValidator

class MockCredentialsValidator: CredentialsValidatorProtocol {
    
    var shouldEmailBeValid: Bool
    var shouldPasswordBeValid: Bool
    var shouldConfirmPasswordBeValid: Bool
    
    init(
        shouldEmailBeValid: Bool,
        shouldPasswordBeValid: Bool,
        shouldConfirmPasswordBeValid: Bool = true
    ) {
        self.shouldEmailBeValid = shouldEmailBeValid
        self.shouldPasswordBeValid = shouldPasswordBeValid
        self.shouldConfirmPasswordBeValid = shouldConfirmPasswordBeValid
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return shouldEmailBeValid
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        return shouldPasswordBeValid
    }
    
    func isConfirmPasswordValid(password: String, confirmPassword: String) -> Bool {
        return shouldConfirmPasswordBeValid
    }
}
