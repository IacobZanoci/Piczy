//
//  WelcomeViewModel.swift
//  WelcomePresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import Foundation

@Observable
public final class WelcomeViewModel: WelcomeViewModelProtocol {
    
    // MARK: - Properties
    
    private let onCreateAccountAction: () -> Void
    private let onLogInAction: () -> Void
    
    // MARK: - Initializers
    
    public init(
        onCreateAccount: @escaping () -> Void,
        onLogIn: @escaping () -> Void
    ) {
        onCreateAccountAction = onCreateAccount
        onLogInAction = onLogIn
    }
    
    // MARK: - Events
    
    public func onCreateAccount() {
        onCreateAccountAction()
    }
    
    public func onLogIn() {
        onLogInAction()
    }
}
