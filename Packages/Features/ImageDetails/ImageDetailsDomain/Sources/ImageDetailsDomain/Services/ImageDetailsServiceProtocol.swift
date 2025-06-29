//
//  ImageDetailsServiceProtocol.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation
import NetworkClient

public protocol ImageDetailsServiceProtocol {
    
    func fetchPictureDetails(
        pictureId: String,
        completion: @Sendable @escaping (Result<UnsplashPictureDetails, NetworkError>) -> Void
    )
}
