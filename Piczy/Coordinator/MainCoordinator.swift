//
//  MainCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import UIKit

final class MainCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    let authenticationCoordinator: AuthenticationCoordinator
    let browseCoordinator: BrowseCoordinator
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.browseCoordinator = BrowseCoordinator(navigationController)
        self.authenticationCoordinator = AuthenticationCoordinator(navigationController)
    }
    
    public func start() {
        authenticationCoordinator.start()
    }
    
    public func startBrowseCoordinator() {
        browseCoordinator.start()
    }
}
