//
//  LoginViewModelProtocol.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@MainActor
public protocol LoginViewModelProtocol {
    
    // MARK: - Properties
    
    var onEmailErrorChanged: ((String?) -> Void)? { get set }
    var onPasswordErrorChanged: ((String?) -> Void)? { get set }
    var onLoginButtonEnabled: ((Bool) -> Void)? { get set }
    
    func onEmailChanged(to email: String)
    
    func onPasswordChanged(to password: String)
    
    /// Event triggered when the user wants to log in.
    func onLogin()
    
    ///Event triggered when the user forgot password.
    func onForgotPassword()
    
    /// Event triggered when the user attempts to create a new account.
    func onCreateAccount()
}
