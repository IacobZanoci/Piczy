//
//  MockLoginServiceForTests.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import Foundation
import LoginPresentation
import LoginDomain
import NetworkClient

class MockLoginServiceForTests: LoginServiceProtocol {
    
    private let expectedSignInResponse: Result<LoginResponse, NetworkError>
    
    public init(expectedSignInResponse: Result<LoginResponse, NetworkError>){
        
        self.expectedSignInResponse = expectedSignInResponse
    }
    
    func signIn(request: LoginRequest, completion: @escaping @Sendable (Result<LoginResponse, NetworkError>) -> Void) {
        
        completion(expectedSignInResponse)
    }
}
