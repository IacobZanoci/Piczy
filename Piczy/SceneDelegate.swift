//
//  SceneDelegate.swift
//  Piczy
//
//  Created by Iacob Zanoci on 17.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    // MARK: - Scene
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController)
        coordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

