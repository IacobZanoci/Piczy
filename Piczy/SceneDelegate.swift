//
//  SceneDelegate.swift
//  Piczy
//
//  Created by Iacob Zanoci on 17.04.2025.
//

import UIKit
import WelcomePresentation

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
        window?.rootViewController = makeWelcomeViewController()
        window?.makeKeyAndVisible()
    }
    
    // MARK: - View Controller Builders
    
    private func makeWelcomeViewController() -> UIViewController {
        let viewModel = WelcomeViewModel(
            onCreateAccount: {
                // Navigate to Create Account screen
            },
            onLogIn: {
                // Navigate to Log In screen
            }
        )
        
        return WelcomeViewController(viewModel: viewModel)
    }
}

