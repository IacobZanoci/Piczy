//
//  MainCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {
    
    // MARK: - Dependencies
    
    var navigationController: UINavigationController
    let dependencyContainer: DependencyContainer
    
    // MARK: - Initializers
    
    init(
        _ navigationController: UINavigationController,
        _ dependencyContainer: DependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Coordinators
    
    lazy var authenticationCoordinator: AuthenticationCoordinator = {
        AuthenticationCoordinator(navigationController,
                                  dependencyContainer: dependencyContainer)
    }()
    
    lazy var browseCoordinator: BrowseCoordinator = {
        BrowseCoordinator(navigationController)
    }()
    
    public func start() {
        authenticationCoordinator.start()
    }
    
    public func startBrowseCoordinator() {
        browseCoordinator.start()
    }
}
