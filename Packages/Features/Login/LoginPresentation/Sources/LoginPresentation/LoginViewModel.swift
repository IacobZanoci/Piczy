//
//  LoginViewModel.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@Observable
public final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Properties
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    private let onLoginAction: () -> Void
    private let onForgotPasswordAction: () -> Void
    private let onCreateAccountAction: () -> Void
    public var onEmailErrorChanged: ((String?) -> Void)?
    public var onPasswordErrorChanged: ((String?) -> Void)?
    public var onLoginButtonEnabled: ((Bool) -> Void)?
    
    public var email: String = "" {
        didSet {
            validateEmail()
            updateLoginButtonState()
        }
    }
    
    public var password: String = "" {
        didSet {
            validatePassword()
            updateLoginButtonState()
        }
    }
    
    // MARK: - Initializers
    
    public init(
        onLogin: @escaping () -> Void,
        onForgotPassword: @escaping () -> Void,
        onCreateAccount: @escaping () -> Void
    ){
        onLoginAction = onLogin
        onForgotPasswordAction = onForgotPassword
        onCreateAccountAction = onCreateAccount
    }
    
    // MARK: - Validation
    
    public func validateEmail() {
        if email.isEmpty || isEmailValid() {
            onEmailErrorChanged?(nil)
        } else {
            onEmailErrorChanged?("The email entered isn't valid.")
        }
    }
    
    public func validatePassword() {
        if isPasswordValid() {
            onPasswordErrorChanged?(nil)
        } else {
            onPasswordErrorChanged?("Password is too short.")
        }
    }
    
    public func updateLoginButtonState() {
        let isButtonEnabled = isEmailValid() && isPasswordValid()
        onLoginButtonEnabled?(isButtonEnabled)
    }
    
    private func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: email)
    }
    
    private func isPasswordValid() -> Bool {
        return password.count > 5
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
