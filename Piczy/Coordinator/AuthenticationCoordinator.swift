//
//  AuthenticationCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit
import WelcomePresentation
import LoginPresentation
import SignUpPresentation

final class AuthenticationCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    let dependencyContainer: DependencyContainer
    private weak var mainCoordinator: MainCoordinator?
    
    init(
        _ navigationController: UINavigationController,
        dependencyContainer: DependencyContainer,
        mainCoordinator: MainCoordinator
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
        self.mainCoordinator = mainCoordinator
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
            onLogin: { [weak self] in
                self?.mainCoordinator?.startBrowseCoordinator()
            },
            onForgotPassword: {
                print("On forgot password button pressed")
            },
            onCreateAccount: { [weak self] in
                self?.goToSignUp()
            },
            credentialsValidator: dependencyContainer.credentialsValidator,
            loginService: dependencyContainer.loginService
        )
        return LoginViewController(viewModel: viewModel)
    }
    
    private func makeSignUpViewController() -> UIViewController {
        let viewModel = SignUpViewModel(
            onSignUp: { [weak self] in
                self?.mainCoordinator?.startBrowseCoordinator()
            },
            credentialsValidator: dependencyContainer.credentialsValidator,
            signUpService: dependencyContainer.signUpService
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
