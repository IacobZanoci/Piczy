//
//  ImageDetailsView.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import UIKit
import DesignSystem
import UIComponents

final class ImageDetailsView: UIView {
    
    // MARK: - Properties
    
    public var onLikeButtonTapped: (Bool) -> Bool
    public var onImageTapped: (() -> Void)?
    
    // MARK: - Views
    
    private lazy var loadingIndicator = LoadingIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = nil
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Piczy.bodyBold
        label.textColor = .Piczy.background
        return label
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Piczy.body
        label.textColor = .Piczy.background
        return label
    }()
    
    private lazy var publishedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .Piczy.background
        label.attributedText = nil
        return label
    }()
    
    private lazy var cameraInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Piczy.body
        label.textColor = .Piczy.background
        return label
    }()
    
    private lazy var licenseInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Piczy.body
        label.textColor = .Piczy.background
        return label
    }()
    
    
    private lazy var blackGradientFadeView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    public lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isHidden = true
        return stackView
    }()
    
    // MARK: - Actions
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
    
    // MARK: - Events
    
    public func setImageLongPressHandler(target: Any?, action: Selector?) {
        imageView.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: target, action: action)
        imageView.addGestureRecognizer(longPressGesture)
    }
    
    func updateImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            loadingIndicator.stopAnimating()
        } else {
            imageView.image = nil
            loadingIndicator.startAnimating()
        }
    }
    
    func updateAuthorName(_ name: String) {
        authorNameLabel.text = name
    }
    
    func updateLocation(_ location: String) {
        locationNameLabel.text = location
    }
    
    func updatePublishedDate(_ date: NSAttributedString?) {
        publishedDateLabel.attributedText = date
    }
    
    func updateCameraInfo(_ cameraInfo: String) {
        cameraInfoLabel.text = cameraInfo
    }
    
    func updateLicenseInfo(_ licenseInfo: NSAttributedString?) {
        licenseInfoLabel.attributedText = licenseInfo
    }
    
    // MARK: - Initializers
    
    init(
        onLikeButtonTapped: @escaping (Bool) -> Bool,
        onImageTapped: @escaping () -> Void
    ) {
        self.onLikeButtonTapped = onLikeButtonTapped
        self.onImageTapped = onImageTapped
        
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Setup

extension ImageDetailsView {
    
    private func setupLayout() {
        setupPictureView()
        setupStackView()
    }
    
    private func setupPictureView() {
        addSubview(imageView)
        addSubview(loadingIndicator)
        
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupStackView() {
        addSubview(blackGradientFadeView)
        detailsStackView.addArrangedSubview(authorNameLabel)
        detailsStackView.addArrangedSubview(locationNameLabel)
        detailsStackView.addArrangedSubview(publishedDateLabel)
        detailsStackView.addArrangedSubview(cameraInfoLabel)
        detailsStackView.addArrangedSubview(licenseInfoLabel)
        addSubview(detailsStackView)
        
        let constraints = [
            blackGradientFadeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blackGradientFadeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blackGradientFadeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blackGradientFadeView.heightAnchor.constraint(equalToConstant: 400),
            
            detailsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            detailsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        // Image tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Animations
    
    func showDetails() {
        UIView.animate(withDuration: 0.3) {
            self.blackGradientFadeView.alpha = 1
            self.detailsStackView.isHidden = false
            self.detailsStackView.alpha = 1
        }
    }
    
    func hideDetails() {
        UIView.animate(withDuration: 0.3) {
            self.blackGradientFadeView.alpha = 0
            self.detailsStackView.isHidden = true
            self.detailsStackView.alpha = 0
        }
    }
}

// MARK: - Preview

#Preview {
    ImageDetailsView(
        onLikeButtonTapped: { _ in true },
        onImageTapped: {}
    )
}
