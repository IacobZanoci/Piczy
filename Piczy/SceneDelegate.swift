//
//  SceneDelegate.swift
//  Piczy
//
//  Created by Iacob Zanoci on 17.04.2025.
//

import UIKit
import WelcomePresentation
import SignUpPresentation

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
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - View Controller Builders
    
    private func makeWelcomeViewController() -> UIViewController {
        let viewModel = WelcomeViewModel(
            onCreateAccount: { [weak self] in
                self?.navigateToSignUp()
            },
            onLogIn: {
                // Navigate to Log In screen
            }
        )
        return WelcomeViewController(viewModel: viewModel)
    }
    
    private func navigateToSignUp() {
        let viewModel = SignUpViewModel(
            onSignUpSuccess: {
                print("SignUp succeeded")
            }
        )
        let signUpVC = SignUpViewController(viewModel: viewModel)
        (window?.rootViewController as? UINavigationController)?
            .pushViewController(signUpVC, animated: true)
    }
}

