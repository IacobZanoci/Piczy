//
//  MockNetworkClient.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

class MockNetworkClient: NetworkClientProtocol {
    var resultToReturn: Result<Data, NetworkError> = .success(Data())
    
    var lastURL: URL?
    var lastMethod: String?
    var lastHeaders: [String: String]?
    var lastQueryItems: [URLQueryItem]?
    var lastBody: Data?
    
    func get(from url: URL,
             headers: [String : String]? = nil,
             queryItems: [URLQueryItem]? = nil,
             completion: @escaping (Result<Data, NetworkError>) -> Void) {
        lastURL = url
        lastMethod = "GET"
        lastHeaders = headers
        lastQueryItems = queryItems
        completion(resultToReturn)
    }
    
    func post(to url: URL,
              body: Encodable,
              headers: [String : String]? = nil,
              queryItems: [URLQueryItem]? = nil,
              completion: @escaping (Result<Data, NetworkError>) -> Void) {
        lastURL = url
        lastMethod = "POST"
        lastHeaders = headers
        lastQueryItems = queryItems
        lastBody = try? JSONEncoder().encode(body)
        completion(resultToReturn)
    }
    
    func put(to url: URL,
             body: Encodable,
             headers: [String : String]? = nil,
             queryItems: [URLQueryItem]? = nil,
             completion: @escaping (Result<Data, NetworkError>) -> Void) {
        lastURL = url
        lastMethod = "PUT"
        lastHeaders = headers
        lastQueryItems = queryItems
        lastBody = try? JSONEncoder().encode(body)
        completion(resultToReturn)
    }
    
    func delete(from url: URL,
                headers: [String : String]? = nil,
                queryItems: [URLQueryItem]? = nil,
                completion: @escaping (Result<Data, NetworkError>) -> Void) {
        lastURL = url
        lastMethod = "DELETE"
        lastHeaders = headers
        lastQueryItems = queryItems
        completion(resultToReturn)
    }
}
