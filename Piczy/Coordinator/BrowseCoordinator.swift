//
//  BrowseCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit
import BrowsePresentation

final class BrowseCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let browseVC = makeBrowseViewController()
        navigationController.setViewControllers([browseVC], animated: false)
    }
}

extension BrowseCoordinator {
    private func makeBrowseViewController() -> UIViewController {
        let viewModel = BrowseViewModel(
            onBrowseAction: {
                print("Browse button tapped")
            },
            onLikesAction: {
                print("Likes button tapped")
            },
            onSettingsAction: {
                print("Settings button tapped")
            },
            onImageSelected: { /*[weak self]*/ selectedImage in
                print("Tapped on an image")
            }
        )
        return BrowseViewController(viewModel: viewModel)
    }
}
