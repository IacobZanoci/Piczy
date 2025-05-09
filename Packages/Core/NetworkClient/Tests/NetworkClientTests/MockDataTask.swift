//
//  MockDataTask.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
@testable import NetworkClient

final class MockDataTask: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    // Fake the network request
    override func resume() {
        closure()
    }
}
