//
//  APIResponse.swift
//  BrowseDomain
//
//  Created by Iacob Zanoci on 30.05.2025.
//

import Foundation

public struct APIResponse: Decodable, Sendable {
    
    let results: [ImageItem]
}
