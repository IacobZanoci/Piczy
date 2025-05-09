//
//  MockURLSession.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
@testable import NetworkClient

public class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
            
            return MockDataTask {
                completionHandler(self.data, self.response, self.error)
            }
        }
}
