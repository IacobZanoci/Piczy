//
//  LoginViewModel.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation
import CredentialsValidator

@Observable
public final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Properties
    
    private let credentialsValidator: CredentialsValidatorProtocol
    private let onLoginAction: () -> Void
    private let onForgotPasswordAction: () -> Void
    private let onCreateAccountAction: () -> Void
    public var onEmailErrorChanged: ((String?) -> Void)?
    public var onPasswordErrorChanged: ((String?) -> Void)?
    public var onLoginButtonEnabled: ((Bool) -> Void)?
    
    private var email: String = "" {
        didSet {
            validateEmail()
            updateLoginButtonState()
        }
    }
    
    private var password: String = "" {
        didSet {
            validatePassword()
            updateLoginButtonState()
        }
    }
    
    // MARK: - Initializers
    
    public init(
        onLogin: @escaping () -> Void,
        onForgotPassword: @escaping () -> Void,
        onCreateAccount: @escaping () -> Void,
        credentialsValidator: CredentialsValidatorProtocol
    ){
        onLoginAction = onLogin
        onForgotPasswordAction = onForgotPassword
        onCreateAccountAction = onCreateAccount
        self.credentialsValidator = credentialsValidator
    }
    
    // MARK: - Validation
    
    private func validateEmail() {
        let hideEmailError = email.isEmpty || credentialsValidator.isEmailValid(email)
        
        if hideEmailError {
            onEmailErrorChanged?(nil)
        } else {
            onEmailErrorChanged?("The email entered isn't valid.")
        }
    }
    
    private func validatePassword() {
        if credentialsValidator.isPasswordValid(password) {
            onPasswordErrorChanged?(nil)
        } else {
            onPasswordErrorChanged?("Password is too short.")
        }
    }
    
    private func updateLoginButtonState() {
        let isButtonEnabled = credentialsValidator.isEmailValid(email) && credentialsValidator.isPasswordValid(password)
        onLoginButtonEnabled?(isButtonEnabled)
    }
    
    // MARK: - Events
    
    public func onEmailChanged(to email: String) {
        self.email = email
    }
    
    public func onPasswordChanged(to password: String) {
        self.password = password
    }
    
    public func onLogin() {
        onLoginAction()
    }
    
    public func onForgotPassword() {
        onForgotPasswordAction()
    }
    
    public func onCreateAccount() {
        onCreateAccountAction()
    }
}
