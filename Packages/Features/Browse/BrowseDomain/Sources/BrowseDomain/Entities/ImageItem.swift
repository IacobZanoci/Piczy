//
//  ImageItem.swift
//  BrowseDomain
//
//  Created by Iacob Zanoci on 02.06.2025.
//

import Foundation

public struct ImageItem: Decodable, Sendable {
    
    public let id: String
    public let urls: ImageUrls
}
