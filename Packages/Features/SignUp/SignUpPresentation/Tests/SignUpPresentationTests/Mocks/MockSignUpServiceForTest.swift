//
//  MockSignUpServiceForTest.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 10.05.2025.
//

import SignUpDomain
import NetworkClient

final class MockSignUpServiceForTest: SignUpServiceProtocol {
    
    private let result: Result<SignUpResponse, NetworkError>
    
    init(result: Result<SignUpResponse, NetworkError>) {
        self.result = result
    }
    
    func signUp(request: SignUpRequest,
                completion: @escaping (Result<SignUpResponse, NetworkError>) -> Void
    ) {
        completion(result)
    }
}
