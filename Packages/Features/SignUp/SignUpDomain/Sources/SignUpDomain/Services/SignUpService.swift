//
//  SignUpService.swift
//  SignUpDomain
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import NetworkClient

public final class SignUpService: SignUpServiceProtocol {
    
    // MARK: - Dependences
    
    private let networkClient: NetworkClientProtocol
    private let url: URL
    
    // MARK: - Initializers
    
    public init(
        networkClient: NetworkClientProtocol,
        url: URL
    ) {
        self.networkClient = networkClient
        self.url = url
    }
    
    // MARK: - Methods
    
    public func signUp(
        request: SignUpRequest,
        completion: @escaping @Sendable (Result<SignUpResponse, NetworkError>) -> Void
    ) {
        let endpoint = url.appendingPathComponent("/signUp/piczy...")
        
        networkClient.post(to: endpoint,
                           body: request,
                           headers: nil,
                           queryItems: nil) { result in
            
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(SignUpResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.decodingError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
