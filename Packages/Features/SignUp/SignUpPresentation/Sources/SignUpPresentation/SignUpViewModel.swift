//
//  SignUpViewModel.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@Observable
public final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Properties
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    private let onSignUpAction: () -> Void
    public var onEmailErrorChanged: ((String?) -> Void)?
    public var onPasswordErrorChanged: ((String?) -> Void)?
    public var onConfirmPasswordErrorChanged: ((String?) -> Void)?
    public var onSignUpButtonEnabled: ((Bool) -> Void)?
    
    public var email: String = "" {
        didSet {
            validateEmail()
            updateSignUpButtonState()
        }
    }
    
    public var password: String = "" {
        didSet {
            validatePassword()
            updateSignUpButtonState()
        }
    }
    
    public var confirmPassword: String = "" {
        didSet {
            validateConfirmPassword()
            updateSignUpButtonState()
        }
    }
    
    // MARK: - Initializers
    
    public init(
        onSignUp: @escaping () -> Void
    ) {
        onSignUpAction = onSignUp
    }
    
    // MARK: - Validation
    
    private func validateEmail() {
        if email.isEmpty || isEmailValid() {
            onEmailErrorChanged?(nil)
        } else {
            onEmailErrorChanged?("Email is not valid")
        }
    }
    
    private func validatePassword() {
        if isPasswordValid() {
            onPasswordErrorChanged?(nil)
        } else {
            onPasswordErrorChanged?("Password is not valid")
        }
    }
    
    private func validateConfirmPassword() {
        if isConfirmPasswordValid() {
            onConfirmPasswordErrorChanged?(nil)
        } else {
            onConfirmPasswordErrorChanged?("Passwords do not match")
        }
    }
    
    private func updateSignUpButtonState() {
        let isButtonEnabled =
        isEmailValid() &&
        isPasswordValid() &&
        isConfirmPasswordValid()
        
        onSignUpButtonEnabled?(isButtonEnabled)
    }
    
    private func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: email)
    }
    
    private func isPasswordValid() -> Bool {
        return password.count > 5
    }
    
    private func isConfirmPasswordValid() -> Bool {
        return confirmPassword == password
    }
    
    // MARK: - Events
    
    public func onEmailChanged(to email: String) {
        self.email = email
    }
    
    public func onPasswordChanged(to password: String) {
        self.password = password
    }
    
    public func onConfirmPasswordChanged(to confirmPassword: String) {
        self.confirmPassword = confirmPassword
    }
    
    public func onSignUp() {
        onSignUpAction()
    }
}
