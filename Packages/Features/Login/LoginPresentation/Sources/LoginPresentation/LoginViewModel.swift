//
//  LoginViewModel.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation
import CredentialsValidator
import LoginDomain
import NetworkClient

@Observable
public final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Dependences
    
    private let credentialsValidator: CredentialsValidatorProtocol
    private let loginService: LoginServiceProtocol
    
    // MARK: - Properties
    
    public var onForgotPasswordAction: () -> Void
    public var onCreateAccountAction: () -> Void
    public var onLoginAction: () -> Void
    public var onEmailErrorChanged: ((String?) -> Void)?
    public var onPasswordErrorChanged: ((String?) -> Void)?
    public var onLoginButtonEnabled: ((Bool) -> Void)?
    public var onErrorCredentials: ((String?) -> Void)?
    public var onLoadingStateChange: ((Bool) -> Void)?
    
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
        credentialsValidator: CredentialsValidatorProtocol,
        loginService: LoginServiceProtocol
    ){
        onLoginAction = onLogin
        onForgotPasswordAction = onForgotPassword
        onCreateAccountAction = onCreateAccount
        self.credentialsValidator = credentialsValidator
        self.loginService = loginService
    }
    
    // MARK: - Validation
    
    private func validateEmail() {
        self.onErrorCredentials?(nil)
        let hideEmailError = email.isEmpty || credentialsValidator.isEmailValid(email)
        
        if hideEmailError {
            onEmailErrorChanged?(nil)
        } else {
            onEmailErrorChanged?("The email entered isn't valid.")
        }
    }
    
    private func validatePassword() {
        self.onErrorCredentials?(nil)
        let hidePasswordError = password.isEmpty || credentialsValidator.isPasswordValid(password)
        
        if hidePasswordError {
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
        let request = LoginRequest(email: email, password: password)
        onLoadingStateChange?(true)
        
        loginService.signIn(request: request) { result in
            DispatchQueue.main.async {
                self.onLoadingStateChange?(false)
                switch result {
                case .success:
                    self.onLoginAction()
                case .failure:
                    self.onErrorCredentials?("Wrong email address or password")
                }
            }
        }
    }
    
    public func onForgotPassword() {
        onForgotPasswordAction()
    }
    
    public func onCreateAccount() {
        onCreateAccountAction()
    }
}
