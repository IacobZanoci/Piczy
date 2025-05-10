//
//  MockSignUpService.swift
//  SignUpDomain
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import NetworkClient

public final class MockSignUpService: SignUpServiceProtocol {
    
    // MARK: - Dependences
    
    private let networkClient: NetworkClientProtocol
    
    // MARK: - Initializers
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    
    public func signUp(
        request: SignUpRequest,
        completion: @escaping (Result<SignUpResponse, NetworkError>) -> Void
    ) {
        if request.email == "piczy@gmail.com" {
            completion(.failure(.emailAlreadyExists))
            return
        }
        
        if request.email.contains("@") &&
            request.password.count > 5 &&
            request.confirmPassword == request.password {
            completion(.success(SignUpResponse(token: "piczyToken")))
        } else {
            completion(.failure(.invalidCredentials))
        }
    }
}
