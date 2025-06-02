//
//  UnsplashEndpoint.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 30.05.2025.
//

import Foundation

public enum UnsplashEndpoint {
    
    case searchPhotos
    case fetchPictureDetails(pictureId: String)
    
    public func endpointURL(using config: UnsplashConfig) -> URL? {
        switch self {
        case .searchPhotos:
            let baseURL = config.baseURL
            let urlString = "\(baseURL)/search/photos"
            return URL(string: urlString)
        case .fetchPictureDetails(pictureId: let pictureId):
            let baseURL = config.baseURL
            let urlString = "\(baseURL)/photos/\(pictureId)"
            return URL(string: urlString)
        }
    }
}
