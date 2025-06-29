//
//  ImageDetailsViewController.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import UIKit
import DesignSystem
import ImageDetailsDomain

public final class ImageDetailsViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private var viewModel: ImageDetailsViewModelProtocol
    private let imageDownloadService: ImageDownloadServiceProtocol
    
    // MARK: - Views
    
    private lazy var imageDetailsView: ImageDetailsView = {
        let view = ImageDetailsView(
            onLikeButtonTapped: { _ in true },
            onImageTapped: {}
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    public init(
        viewModel: ImageDetailsViewModelProtocol,
        imageDownloadService: ImageDownloadServiceProtocol
    ) {
        self.viewModel = viewModel
        self.imageDownloadService = imageDownloadService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        imageDetailsView.updateImage(nil)
        imageDetailsView.setImageLongPressHandler(target: self, action: #selector(handleLongPressOnImage))
        bindViewModel()
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.backgroundColor = .Piczy.background
        view.addSubview(imageDetailsView)
        
        let constraints = [
            imageDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            imageDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // Setup nav bar `like` button
    private func setupNavigationBar() {
        let likeButton = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(likeButtonTapped)
        )
        
        likeButton.tintColor = .Piczy.primaryText
        navigationItem.rightBarButtonItem = likeButton
        
        updateLikeButtonIcon()
    }
    
    private func updateLikeButtonIcon() {
        let imageName = viewModel.isLiked ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    private func toggleDetailsVisibility() {
        if imageDetailsView.detailsStackView.isHidden {
            imageDetailsView.showDetails()
        } else {
            imageDetailsView.hideDetails()
        }
    }
    
    // MARK: - Actions
    
    @objc private func likeButtonTapped() {
        viewModel.toggleLike()
        updateLikeButtonIcon()
    }
    
    @objc private func handleLongPressOnImage(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let alert = UIAlertController(
            title: "Save Image",
            message: "Do you want to save this image?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Save",
                                      style: .default,
                                      handler: { _ in self.saveImage() })
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Events
    
    private func bindViewModel() {
        
        // Like button - react to viewModel state change
        viewModel.onLikedStateChanged = { [ weak self ] isLiked in
            self?.updateLikeButtonIcon()
        }
        
        // Like button - handle like button tap from the view
        imageDetailsView.onLikeButtonTapped = { [weak self] isLiked in
            self?.viewModel.toggleLike()
            return self?.viewModel.isLiked ?? false
        }
        
        // Handle image tap to toggle details visibility
        imageDetailsView.onImageTapped = { [weak self] in
            self?.toggleDetailsVisibility()
        }
        
        viewModel.onDataFetched = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageDetailsView.updateImage(self.viewModel.image)
                self.imageDetailsView.updateAuthorName(self.viewModel.displayAuthorName)
                self.imageDetailsView.updateLocation(self.viewModel.displayLocation)
                self.imageDetailsView.updatePublishedDate(self.viewModel.displayPublishedDate)
                self.imageDetailsView.updateCameraInfo(self.viewModel.displayCameraInfo)
                self.imageDetailsView.updateLicenseInfo(self.viewModel.displayLicenseInfo)
            }
            
            
        }
        
    }
    
    private func saveImage() {
        viewModel.saveImage { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.showResultAlert(title: "Saved", message: "Image saved to your library.")
            case .failure(let error):
                self.showResultAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
