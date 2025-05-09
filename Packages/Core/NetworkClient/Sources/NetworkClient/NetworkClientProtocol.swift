//
//  NetworkClientProtocol.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

public protocol NetworkClientProtocol {
    func get(from url: URL,
             headers: [String: String]?,
             queryItems: [URLQueryItem]?,
             completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    )
    
    func post(to url: URL,
              body: Encodable,
              headers: [String: String]?,
              queryItems: [URLQueryItem]?,
              completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    )
    
    func put(to url: URL,
             body: Encodable,
             headers: [String: String]?,
             queryItems: [URLQueryItem]?,
             completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    )
    
    func delete(from url: URL,
                headers: [String: String]?,
                queryItems: [URLQueryItem]?,
                completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    )
}
