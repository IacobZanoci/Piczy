//
//  SignUpViewModelProtocol.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@MainActor
public protocol SignUpViewModelProtocol {
    
    // MARK: - Properties
    
    var onEmailErrorChanged: ((String?) -> Void)? { get set }
    var onPasswordErrorChanged: ((String?) -> Void)? { get set }
    var onConfirmPasswordErrorChanged: ((String?) -> Void)? { get set }
    var onSignUpButtonEnabled: ((Bool) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    // MARK: - Methods
    
    func onEmailChanged(to email: String)
    func onPasswordChanged(to password: String)
    func onConfirmPasswordChanged(to confirmPassword: String)
    
    // MARK: - Events
    
    /// Event triggered when the user wants to sign up.
    func onSignUp()
}
