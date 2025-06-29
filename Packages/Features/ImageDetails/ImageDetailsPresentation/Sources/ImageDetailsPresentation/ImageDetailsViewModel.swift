//
//  ImageDetailsViewModel.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import Foundation
import UIKit
import ImageDetailsDomain

@Observable
public final class ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let imageDetailsService: ImageDetailsServiceProtocol
    private let imageDownloadService: ImageDownloadServiceProtocol
    
    // MARK: - Properties
    
    public var error: ImageDetailsError? = nil
    public var image: UIImage? = nil
    
    public var imageURL: URL
    public var authorName: String
    public var location: String
    public var publishedDate: String
    public var cameraInfo: String
    public var licenseInfo: String
    
    public var onLikedStateChanged: ((Bool) -> Void)?
    
    public var isLiked: Bool = false {
        didSet {
            onLikedStateChanged?(isLiked)
        }
    }
    
    public var onDataFetched: (() -> Void)?
    
    // MARK: - Computed properties
    
    public var displayAuthorName: String {
        return authorName.isEmpty
        ? "Unknown Author"
        : authorName
    }
    
    public var displayLocation: String {
        return location.isEmpty
        ? "Unknown Location"
        : location
    }
    
    public var displayPublishedDate: NSAttributedString? {
        guard !publishedDate.isEmpty else { return nil }
        
        let firstPart = "Published "
        let secondPart = publishedDate
        let thirdPart = " ago"
        
        let attributedText = NSMutableAttributedString(
            string: firstPart,
            attributes: [.font: UIFont.Piczy.body]
        )
        
        let boldText = NSAttributedString(
            string: secondPart,
            attributes: [.font: UIFont.Piczy.bodyBold]
        )
        
        let lastText = NSAttributedString(
            string: thirdPart,
            attributes: [.font: UIFont.Piczy.body]
        )
        
        attributedText.append(boldText)
        attributedText.append(lastText)
        
        return attributedText
    }
    
    public var displayCameraInfo: String {
        return cameraInfo.isEmpty
        ? "Unknown Camera Info"
        : cameraInfo
    }
    
    public var displayLicenseInfo: NSAttributedString? {
        let fullText = "Free to use under the Unsplash License"
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
    
    // MARK: - Initializers
    
    public init(
        imageURL: URL,
        authorName: String = "",
        location: String = "",
        publishedDate: String = "",
        cameraInfo: String = "",
        licenseInfo: String = "",
        pictureID: String,
        imageDetailsService: ImageDetailsServiceProtocol,
        imageDownloadService: ImageDownloadServiceProtocol
    ) {
        self.imageURL = imageURL
        self.authorName = authorName
        self.location = location
        self.publishedDate = publishedDate
        self.cameraInfo = cameraInfo
        self.licenseInfo = licenseInfo
        self.imageDetailsService = imageDetailsService
        self.imageDownloadService = imageDownloadService
        
        fetchPictureDetails(pictureId: pictureID)
    }
    
    // MARK: - Actions
    
    public func toggleLike() {
        isLiked.toggle()
        onLikedStateChanged?(isLiked)
    }
    
    // MARK: - Methods
    
    public func fetchImage(completion: @escaping (UIImage?) -> Void) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    print("Fetched image successfully")
                    completion(image)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to load the image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    private func fetchPictureDetails(pictureId: String) {
        imageDetailsService.fetchPictureDetails(pictureId: pictureId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let details):
                let imageURL = URL(string: details.urls.regular)
                print("Fetched details: \(details)")
                let authorName = details.user.name
                let location = [details.location?.city, details.location?.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                let cameraInfo = [details.exif?.make, details.exif?.model]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                let createdAt = details.createdAt
                
                // Update UI
                Task { @MainActor in
                    self.imageURL = imageURL ?? self.imageURL
                    self.authorName = authorName
                    self.location = location
                    self.publishedDate = self.formatDate(createdAt)
                    self.cameraInfo = cameraInfo
                    self.fetchImage { image in
                        DispatchQueue.main.async {
                            self.image = image
                            self.onDataFetched?()
                        }
                    }
                }
                
            case .failure(let error):
                print("Error fetching picture details:", error)
            }
        }
    }
    
    // Returns short date format (3 days ago, 3 yeaars ago)
    private func formatDate(_ date: Date) -> String {
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    /// Method for saving images to the phone library.
    public func saveImage(completion: @escaping (Result<Void, Error>) -> Void) {
        imageDownloadService.downloadImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fileURL):
                    if let image = UIImage(contentsOfFile: fileURL.path) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        completion(.success(()))
                    } else {
                        self.error = .saveFailed
                        completion(.failure(ImageDetailsError.saveFailed))
                    }
                case .failure:
                    self.error = .downloadFailed
                    completion(.failure(ImageDetailsError.downloadFailed))
                }
            }
        }
    }
}
