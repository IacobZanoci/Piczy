//
//  BrowseCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit

final class BrowseCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Navigate to the main screen after successful authentication
    }
}
