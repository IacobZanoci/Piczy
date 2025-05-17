//
//  ImageDetailsViewModel.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import Foundation
import UIKit

@Observable
public final class ImageDetailsViewModel: ImageDetailsViewModelProtocol {
    
    // MARK: - Properties
    
    public var image: UIImage? = nil
    
    public let imageURL: URL
    public let authorName: String
    public let location: String
    public let publishedDate: String
    public let cameraInfo: String
    public let licenseInfo: String
    
    public var onLikedStateChanged: ((Bool) -> Void)?
    
    public var isLiked: Bool = false {
        didSet {
            onLikedStateChanged?(isLiked)
        }
    }
    
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
        guard !licenseInfo.isEmpty else { return nil }
        
        let fullText = licenseInfo.isEmpty
        ? "Unknown License"
        : licenseInfo
        
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.Piczy.body
            ]
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
        authorName: String,
        location: String,
        publishedDate: String,
        cameraInfo: String,
        licenseInfo: String
    ) {
        self.imageURL = imageURL
        self.authorName = authorName
        self.location = location
        self.publishedDate = publishedDate
        self.cameraInfo = cameraInfo
        self.licenseInfo = licenseInfo
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
                if let downloadedImage = UIImage(data: data) {
                    completion(downloadedImage)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to load the image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
