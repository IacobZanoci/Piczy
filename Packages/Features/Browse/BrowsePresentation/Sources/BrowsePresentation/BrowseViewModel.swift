//
//  BrowseViewModel.swift
//  BrowsePresentation
//
//  Created by Iacob Zanoci on 20.05.2025.
//

import Foundation

@Observable
public final class BrowseViewModel: BrowseViewModelProtocol {
    
    // MARK: - Properties
    
    public var imageUrls: [ImageItem] = []
    public var onImageSelected: ((ImageItem) -> Void)?
    public var onImagesUpdated: (() -> Void)?
    public var onBrowseAction: () -> Void
    public var onLikesAction: () -> Void
    public var onSettingsAction: () -> Void
    private var searchDebounceTask: DispatchWorkItem?
    
    public var searchQuery: String = "" {
        didSet {
            guard oldValue != searchQuery else { return }
            
            searchDebounceTask?.cancel()
            
            let task = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.fetchImages()
            }
            
            searchDebounceTask = task
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        }
    }
    
    // MARK: - Initializers
    
    public init(
        onBrowseAction: @escaping () -> Void,
        onLikesAction: @escaping () -> Void,
        onSettingsAction: @escaping () -> Void,
        onImageSelected: ((ImageItem) -> Void)?
    ){
        self.onBrowseAction = onBrowseAction
        self.onLikesAction = onLikesAction
        self.onSettingsAction = onSettingsAction
        self.onImageSelected = onImageSelected
    }
    
    // MARK: - Events
    
    public func fetchImages() {
        guard !searchQuery.isEmpty else {
            self.imageUrls = []
            onImagesUpdated?()
            return
        }
    }
    
    public func didSelectItemAt(indexPath: IndexPath) {
        let selectedImage = imageUrls[indexPath.item]
        onImageSelected?(selectedImage)
    }
    
    public func onBrowse() {
        onBrowseAction()
    }
    
    public func onLikes() {
        onLikesAction()
    }
    
    public func onSettings() {
        onSettingsAction()
    }
}
