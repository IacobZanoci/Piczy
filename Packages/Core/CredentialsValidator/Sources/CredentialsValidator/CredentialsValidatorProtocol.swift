//
//  CredentialsValidatorProtocol.swift
//  CredentialsValidator
//
//  Created by Iacob Zanoci on 07.05.2025.
//

import Foundation

public protocol CredentialsValidatorProtocol {
    
    func isEmailValid(_ email: String) -> Bool
    func isPasswordValid(_ password: String) -> Bool
    func isConfirmPasswordValid(password: String, confirmPassword: String) -> Bool
}
