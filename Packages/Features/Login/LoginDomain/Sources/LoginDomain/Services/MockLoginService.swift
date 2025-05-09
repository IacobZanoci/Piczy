//
//  MockLoginService.swift
//  LoginDomain
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import NetworkClient

public class MockLoginService: LoginServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    public func signIn(request: LoginRequest, completion: @escaping @Sendable (Result<LoginResponse, NetworkError>) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if request.email == "piczy@gmail.com" && request.password == "123456" {
                completion(.success(LoginResponse(token: "piczyToken")))
            } else {
                completion(.failure(.invalidCredentials))
            }
        }
    }
}
