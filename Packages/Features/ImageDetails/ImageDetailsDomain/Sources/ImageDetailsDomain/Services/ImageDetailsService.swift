//
//  ImageDetailsService.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation
import NetworkClient

public class ImageDetailsService: ImageDetailsServiceProtocol {
    
    // MARK: - Dependencies
    
    private let networkManager: NetworkClientProtocol
    private let config: UnsplashConfig
    
    // MARK: - Initializers
    
    public init(
        networkManager: NetworkClientProtocol,
        config: UnsplashConfig
    ) {
        self.networkManager = networkManager
        self.config = config
    }
    
    // MARK: - Methods
    
    public func fetchPictureDetails(
        pictureId: String,
        completion: @Sendable @escaping (Result<UnsplashPictureDetails, NetworkError>) -> Void
    ) {
        guard let endpointURL = UnsplashEndpoint
            .fetchPictureDetails(pictureId: pictureId)
            .endpointURL(using: config) else {
            completion(.failure(.invalidURL))
            return
        }
        
        networkManager.get(
            from: endpointURL,
            headers: ["Authorization": "Client-ID \(config.accessKey)"],
            queryItems: nil
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(UnsplashPictureDetails.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("JSON Decoding failed:", error)
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
