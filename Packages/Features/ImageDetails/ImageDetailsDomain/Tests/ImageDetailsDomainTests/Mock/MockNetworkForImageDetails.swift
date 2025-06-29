//
//  MockNetworkForImageDetails.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 29.06.2025.
//

import Foundation
import NetworkClient

final class MockNetworkForImageDetails: NetworkClientProtocol {
    var result: Result<Data, NetworkError>!
    
    func get(
        from url: URL,
        headers: [String : String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        completion(result)
    }
    
    func post(
        to url: URL,
        body: Encodable,
        headers: [String : String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        completion(result)
    }
    
    func put(
        to url: URL,
        body: Encodable,
        headers: [String : String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        completion(result)
    }
    
    func delete(
        from url: URL,
        headers: [String : String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        completion(result)
    }
}
