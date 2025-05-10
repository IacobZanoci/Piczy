//
//  SignUpViewModel.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation
import SignUpDomain
import CredentialsValidator

@Observable
public final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Dependences
    
    private let credentialsValidator: CredentialsValidatorProtocol
    private let signUpService: SignUpServiceProtocol
    
    // MARK: - Properties
    
    private let onSignUpAction: () -> Void
    public var onEmailErrorChanged: ((String?) -> Void)?
    public var onPasswordErrorChanged: ((String?) -> Void)?
    public var onConfirmPasswordErrorChanged: ((String?) -> Void)?
    public var onSignUpButtonEnabled: ((Bool) -> Void)?
    
    private var email: String = "" {
        didSet {
            validateEmail()
            updateSignUpButtonState()
        }
    }
    
    private var password: String = "" {
        didSet {
            validatePassword()
            updateSignUpButtonState()
        }
    }
    
    private var confirmPassword: String = "" {
        didSet {
            validateConfirmPassword()
            updateSignUpButtonState()
        }
    }
    
    // MARK: - Initializers
    
    public init(
        onSignUp: @escaping () -> Void,
        credentialsValidator: CredentialsValidatorProtocol,
        signUpService: SignUpServiceProtocol
    ) {
        onSignUpAction = onSignUp
        self.credentialsValidator = credentialsValidator
        self.signUpService = signUpService
    }
    
    // MARK: - Validation
    
    private func validateEmail() {
        if (email.isEmpty) || (credentialsValidator.isEmailValid(email)) {
            onEmailErrorChanged?(nil)
        } else {
            onEmailErrorChanged?("Email is not valid")
        }
    }
    
    private func validatePassword() {
        if (password.isEmpty) || (credentialsValidator.isPasswordValid(password)) {
            onPasswordErrorChanged?(nil)
        } else {
            onPasswordErrorChanged?("Password is not valid")
        }
    }
    
    private func validateConfirmPassword() {
        if (confirmPassword.isEmpty) || (credentialsValidator.isConfirmPasswordValid(password: password,
                                                                                     confirmPassword: confirmPassword)) {
            onConfirmPasswordErrorChanged?(nil)
        } else {
            onConfirmPasswordErrorChanged?("Passwords do not match")
        }
    }
    
    private func updateSignUpButtonState() {
        let isButtonEnabled =
        credentialsValidator.isEmailValid(email) &&
        credentialsValidator.isPasswordValid(password) &&
        credentialsValidator.isConfirmPasswordValid(password: password, confirmPassword: confirmPassword)
        
        onSignUpButtonEnabled?(isButtonEnabled)
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
        let request = SignUpRequest(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        signUpService.signUp(request: request) { [weak self] result in
            
            let errorMessage: String?
            let token: String?
            
            switch result {
            case .success(let response):
                token = response.token
                errorMessage = nil
            case .failure(let error):
                token = nil
                switch error {
                case .emailAlreadyExists:
                    errorMessage = "Email already in use"
                default:
                    errorMessage = "Unknown error"
                }
            }
            
            DispatchQueue.main.async {
                if let token = token {
                    print("Signed Up with token: \(token)")
                    self?.onEmailErrorChanged?(nil)
                    self?.onSignUpAction()
                } else if let message = errorMessage {
                    self?.onEmailErrorChanged?(message)
                }
            }
        }
    }
}
