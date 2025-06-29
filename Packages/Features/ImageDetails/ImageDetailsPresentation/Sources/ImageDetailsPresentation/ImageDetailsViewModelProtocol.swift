//
//  ImageDetailsViewModelProtocol.swift
//  ImageDetailsPresentation
//
//  Created by Iacob Zanoci on 17.05.2025.
//

import UIKit

@MainActor
public protocol ImageDetailsViewModelProtocol: AnyObject {
    
    // MARK: - Properties
    
    var imageURL: URL { get }
    var authorName: String { get }
    var location: String { get }
    var publishedDate: String { get }
    var cameraInfo: String { get }
    var licenseInfo: String { get }
    
    var onLikedStateChanged: ((Bool) -> Void)? { get set }
    var isLiked: Bool { get set }
    var onDataFetched: (() -> Void)? { get set }
    var image: UIImage? { get }
    
    // MARK: - Computed properties
    
    var displayAuthorName: String { get }
    var displayLocation: String { get }
    var displayPublishedDate: NSAttributedString? { get }
    var displayCameraInfo: String { get }
    var displayLicenseInfo: NSAttributedString? { get }
    
    // MARK: - Methods
    
    /// Method for fetching images.
    func fetchImage(completion: @escaping (UIImage?) -> Void)
    
    /// Method for saving images to the local library.
    func saveImage(completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Togle the `Like` state from ImageDetailsView.
    func toggleLike()
}
