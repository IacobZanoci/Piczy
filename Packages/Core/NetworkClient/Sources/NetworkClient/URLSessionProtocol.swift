//
//  URLSessionProtocol.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
