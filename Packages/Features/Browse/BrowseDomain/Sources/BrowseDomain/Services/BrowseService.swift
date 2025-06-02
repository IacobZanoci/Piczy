//
//  BrowseService.swift
//  BrowseDomain
//
//  Created by Iacob Zanoci on 02.06.2025.
//

import Foundation
import NetworkClient

public final class BrowseService: BrowseServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let config: UnsplashConfig
    
    public init(networkClient: NetworkClientProtocol, config: UnsplashConfig) {
        self.networkClient = networkClient
        self.config = config
    }
    
    public func fetchImages(page: Int, searchQuery: String?, completion: @escaping @Sendable (Result<[ImageItem], Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "query", value: searchQuery)
        ]
        let headers = ["Authorization": "Client-ID \(config.accessKey)"]
        
        guard let searchQuery = searchQuery, !searchQuery.isEmpty else {
            completion(.failure(NetworkError.invalidQuery))
            return
        }
        
        guard let endpointURL = UnsplashEndpoint.searchPhotos.endpointURL(using: config) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkClient.get(from: endpointURL, headers: headers, queryItems: queryItems) { result in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(items.results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
