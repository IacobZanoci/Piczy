//
//  LoginService.swift
//  LoginDomain
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import NetworkClient

final class LoginService: LoginServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let url = URL(string: "https://server-api-url.com")!
    let headers: [String: String] = ["Content-Type": "application/json"]
    let queryItems: [URLQueryItem]? = nil
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    public func signIn(request: LoginRequest, completion: @escaping @Sendable (Result<LoginResponse, NetworkError>) -> Void) {
        
        networkClient.post(to: url,
                           body: request,
                           headers: headers,
                           queryItems: queryItems) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.invalidCredentials))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
