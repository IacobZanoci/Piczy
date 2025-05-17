//
//  ImageDetailsViewController.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import UIKit
import DesignSystem

public final class ImageDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: ImageDetailsViewModelProtocol
    
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
    
    public init(viewModel: ImageDetailsViewModelProtocol) {
        self.viewModel = viewModel
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
    
    // MARK: - Events
    
    private func bindViewModel() {
        // get pictures
        viewModel.fetchImage { [weak self] image in
            self?.imageDetailsView.updateImage(image)
        }
        
        // author name
        imageDetailsView.updateAuthorName(viewModel.displayAuthorName)
        
        // location
        imageDetailsView.updateLocation(viewModel.displayLocation)
        
        // published date
        imageDetailsView.updatePublishedDate(viewModel.displayPublishedDate)
        
        // camera info
        imageDetailsView.updateCameraInfo(viewModel.displayCameraInfo)
        
        // license info
        imageDetailsView.updateLicenseInfo(viewModel.displayLicenseInfo)
        
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
    }
}

// MARK: - Preview

private final class ViewModelFixture: ImageDetailsViewModelProtocol {
    var imageURL: URL = URL(string: "https://example.com/image.jpg")!
    var authorName: String = ""
    var location: String = ""
    var publishedDate: String = "3 days"
    var cameraInfo: String = ""
    var licenseInfo: String = "Free to use under the Unsplash License"
    
    var displayAuthorName: String { "Iacob Zanoci" }
    var displayLocation: String { "Cabo San Lucas, BCS, Mexico" }
    var displayPublishedDate: NSAttributedString? {
        guard !publishedDate.isEmpty else { return nil }
        
        let regularFont = UIFont.Piczy.body
        let boldFont = UIFont.Piczy.bodyBold
        
        let fullText = NSMutableAttributedString(string: "Published ", attributes: [.font: regularFont])
        fullText.append(NSAttributedString(string: publishedDate, attributes: [.font: boldFont]))
        fullText.append(NSAttributedString(string: " ago", attributes: [.font: regularFont]))
        return fullText
    }
    var displayCameraInfo: String { "Canon, EOS RP" }
    var displayLicenseInfo: NSAttributedString? {
        guard !licenseInfo.isEmpty else { return nil }
        
        let fullText = licenseInfo.isEmpty ? "Unknown License" : licenseInfo
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: UIFont.Piczy.body]
        )
        let underlineText = "Unsplash License"
        
        if let range = fullText.range(of: underlineText) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        return attributedText
    }
    
    var onLikedStateChanged: ((Bool) -> Void)?
    var isLiked: Bool = false
    
    func fetchImage(completion: @escaping (UIImage?) -> Void) {}
    func toggleLike() { isLiked.toggle() }
}

#Preview {
    UINavigationController(
        rootViewController: ImageDetailsViewController(
            viewModel: ViewModelFixture()
        )
    )
}
