//
//  WelcomeViewModelProtocol.swift
//  WelcomePresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@MainActor
public protocol WelcomeViewModelProtocol {
    
    /// Event triggered when the user attempts to create a new account.
    func onCreateAccount()
    
    /// Event triggered when the user attempts to log in to their account.
    func onLogIn()
}
