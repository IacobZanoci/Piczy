//
//  ImageDetailsError.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation

public enum ImageDetailsError: Error, LocalizedError {

    // Metadata Image
    case metadataDecodingFailed
    case metadataNotFound
    case network(Error)

    // Download Image
    case invalidURL
    case downloadFailed
    case networkTimeout
    case saveFailed

    public var errorDescription: String? {
        switch self {
        case .metadataDecodingFailed:
            return "Failed to decode image metadata."
        case .metadataNotFound:
            return "No metadata found for this image."
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid image download URL."
        case .downloadFailed:
            return "Could not download the image."
        case .networkTimeout:
            return "The network request timed out."
        case .saveFailed:
            return "Could not save the image to your library."
        }
    }
}
