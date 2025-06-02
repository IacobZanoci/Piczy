//
//  BrowseServiceProtocol.swift
//  BrowseDomain
//
//  Created by Iacob Zanoci on 02.06.2025.
//

import Foundation

public protocol BrowseServiceProtocol {
    
    func fetchImages(page: Int, searchQuery: String?, completion: @escaping @Sendable (Result<[ImageItem], Error>) -> Void)
}
