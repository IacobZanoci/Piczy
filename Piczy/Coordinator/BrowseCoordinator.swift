//
//  BrowseCoordinator.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit
import BrowsePresentation
import BrowseDomain
import ImageDetailsPresentation
import ImageDetailsDomain

final class BrowseCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    let dependencyContainer: DependencyContainer
    private weak var mainCoordinator: MainCoordinator?
    
    init(_ navigationController: UINavigationController,
         dependencyContainer: DependencyContainer
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
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
            onImageSelected: { [weak self] selectedImage in
                self?.showImageDetails(for: selectedImage)
                print("Tapped on an image: \(selectedImage)")
            },
            browseService: dependencyContainer.browseService
        )
        return BrowseViewController(viewModel: viewModel)
    }
    
    private func showImageDetails(for image: ImageItem) {
        guard let url = URL(string: image.urls.regular) else {
            print("Invalid image URL")
            return
        }
        
        let viewModel = ImageDetailsViewModel(
            imageURL: url,
            pictureID: image.id,
            imageDetailsService: dependencyContainer.imageDetailsService,
            imageDownloadService: dependencyContainer.imageDownloadService
        )
        
        let detailsVC = ImageDetailsViewController(
            viewModel: viewModel,
            imageDownloadService: dependencyContainer.imageDownloadService
        )
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
