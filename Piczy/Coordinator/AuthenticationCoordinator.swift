//
//  AuthenticationCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import UIKit
import WelcomePresentation
import LoginPresentation
import SignUpPresentation
import CredentialsValidator

final class AuthenticationCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeVC = makeWelcomeViewController()
        navigationController.setViewControllers([welcomeVC], animated: false)
    }
    
    func goToSignUp() {
        let signVC = makeSignUpViewController()
        navigationController.pushViewController(signVC, animated: true)
    }
    
    func goToLogin() {
        let loginVC = makeLoginViewController()
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func goToForgotPassword() {
        // Navigate to the Forgot Password screen
    }
}

extension AuthenticationCoordinator {
    
    private func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(
            onLogin: {
                print("On login button pressed")
            },
            onForgotPassword: {
                print("On forgot password button pressed")
            },
            onCreateAccount: { [weak self] in
                self?.goToSignUp()
            },
            credentialsValidator: CredentialsValidator()
        )
        return LoginViewController(viewModel: viewModel)
    }
    
    private func makeSignUpViewController() -> UIViewController {
        let viewModel = SignUpViewModel(
            onSignUp: {
                print("SignUp succeeded")
            },
            credentialsValidator: CredentialsValidator()
        )
        return SignUpViewController(viewModel: viewModel)
    }
    
    private func makeWelcomeViewController() -> UIViewController {
        let viewModel = WelcomeViewModel(
            onCreateAccount: { [weak self] in
                self?.goToSignUp()
            },
            onLogIn: { [weak self] in
                self?.goToLogin()
            }
        )
        return WelcomeViewController(viewModel: viewModel)
    }
}
