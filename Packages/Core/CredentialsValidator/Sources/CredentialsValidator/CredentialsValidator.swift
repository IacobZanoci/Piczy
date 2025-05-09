//
//  CredentialsValidator.swift
//  CredentialsValidator
//
//  Created by Iacob Zanoci on 07.05.2025.
//

import Foundation

public class CredentialsValidator: CredentialsValidatorProtocol {
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    
    public init() {}
    
    public func isEmailValid(_ email: String) -> Bool {
        return emailPredicate.evaluate(with: email)
    }
    
    public func isPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
    public func isConfirmPasswordValid(password: String, confirmPassword: String) -> Bool {
        return confirmPassword == password
    }
}
