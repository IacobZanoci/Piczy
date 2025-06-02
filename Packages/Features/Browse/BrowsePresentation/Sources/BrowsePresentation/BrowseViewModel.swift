//
//  BrowseViewModel.swift
//  BrowsePresentation
//
//  Created by Iacob Zanoci on 20.05.2025.
//

import Foundation
import BrowseDomain

@Observable
public final class BrowseViewModel: BrowseViewModelProtocol {
    
    // MARK: - Properties
    
    private let browseService: BrowseServiceProtocol
    public var imageUrls: [ImageItem] = []
    public var onImageSelected: ((ImageItem) -> Void)?
    public var onImagesUpdated: (() -> Void)?
    public var onBrowseAction: () -> Void
    public var onLikesAction: () -> Void
    public var onSettingsAction: () -> Void
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var searchDebounceTask: DispatchWorkItem?
    
    public var searchQuery: String = "" {
        didSet {
            guard oldValue != searchQuery else { return }
            
            searchDebounceTask?.cancel()
            
            let task = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.currentPage = 1
                self.imageUrls = []
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
        onImageSelected: ((ImageItem) -> Void)?,
        browseService: BrowseServiceProtocol
    ){
        self.onBrowseAction = onBrowseAction
        self.onLikesAction = onLikesAction
        self.onSettingsAction = onSettingsAction
        self.onImageSelected = onImageSelected
        self.browseService = browseService
    }
    
    // MARK: - Methods
    
    public func fetchImages() {
        guard !searchQuery.isEmpty, !isLoading else {
            if searchQuery.isEmpty {
                self.imageUrls = []
                onImagesUpdated?()
            }
            return
        }
        
        isLoading = true
        
        browseService.fetchImages(page: currentPage, searchQuery: searchQuery) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let images):
                    if self.currentPage == 1 {
                        self.imageUrls = images
                    } else {
                        self.imageUrls += images
                    }
                    self.currentPage += 1
                    self.onImagesUpdated?()
                    
                case .failure(let error):
                    print("Error fetching images: \(error.localizedDescription)")
                }
            }
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
