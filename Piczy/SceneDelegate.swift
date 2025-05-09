//
//  SceneDelegate.swift
//  Piczy
//
//  Created by Iacob Zanoci on 17.04.2025.
//

import UIKit
import WelcomePresentation
import SignUpPresentation
import LoginPresentation
import CredentialsValidator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Scene Delegate Methods
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let welcomeVC = makeWelcomeViewController()
        let navController = UINavigationController(rootViewController: welcomeVC)
        window?.rootViewController = makeWelcomeViewController()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - View Controller Builders
    
    private func makeWelcomeViewController() -> UIViewController {
        let viewModel = WelcomeViewModel(
            onCreateAccount: {
                self.navigateToSignUp()
            },
            onLogIn: {
                self.navigateToLogin()
            }
        )
        return WelcomeViewController(viewModel: viewModel)
    }
    
    private func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(
            onLogin: {
                print("On login button pressed")
            },
            onForgotPassword: {
                print("On forgot password button pressed")
            },
            onCreateAccount: {
                print("On create account button pressed")
            },
            credentialsValidator: CredentialsValidator()
        )
        return LoginViewController(viewModel: viewModel)
        
    }
    
    private func navigateToSignUp() {
        let viewModel = SignUpViewModel(
            onSignUp: {
                print("SignUp succeeded")
            }
        )
        let signUpVC = SignUpViewController(viewModel: viewModel)
        (window?.rootViewController as? UINavigationController)?
            .pushViewController(signUpVC, animated: true)
    }
    
    private func navigateToLogin() {
        let viewModel = LoginViewModel(
            onLogin: {
                print("Login button pressed")
            },
            onForgotPassword: {
                print("Forgot password button pressed")
            },
            onCreateAccount: {
                print("Create account button pressed")
            },
            credentialsValidator: CredentialsValidator()
        )
        let loginVC = LoginViewController(viewModel: viewModel)
        (window?.rootViewController as? UINavigationController)?
            .pushViewController(loginVC, animated: true)
    }
}

