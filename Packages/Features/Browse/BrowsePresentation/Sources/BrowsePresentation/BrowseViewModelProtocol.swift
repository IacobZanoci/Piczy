//
//  BrowseViewModelProtocol.swift
//  BrowsePresentation
//
//  Created by Iacob Zanoci on 19.05.2025.
//

import Foundation


public protocol BrowseViewModelProtocol {
    var imageUrls: [ImageItem] { get }
    var onImagesUpdated: (() -> Void)? { get set }
    var onBrowseAction: () -> Void { get set }
    var onLikesAction: () -> Void { get set }
    var onSettingsAction: () -> Void { get set }
    var searchQuery: String { get set }
    var onImageSelected: ((ImageItem) -> Void)? { get set }
    
    func didSelectItemAt(indexPath: IndexPath)
    
    func fetchImages()
    
    func onBrowse()
    
    func onLikes()
    
    func onSettings()
}
