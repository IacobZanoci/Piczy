//
//  NetworkClient.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

public final class NetworkClient: NetworkClientProtocol {
    private let urlSession: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - GET
    
    public func get(from url: URL,
                    headers: [String: String]? = nil,
                    queryItems: [URLQueryItem]? = nil,
                    completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: configureQueryParameters(for: url, with: queryItems))
        request.httpMethod = "GET"
        configureHeaders(for: &request, with: headers)
        perform(request, completion: completion)
    }
    
    // MARK: - POST
    
    public func post(to url: URL,
                     body: Encodable,
                     headers: [String: String]? = nil,
                     queryItems: [URLQueryItem]? = nil,
                     completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: configureQueryParameters(for: url, with: queryItems))
        request.httpMethod = "POST"
        configureHeaders(for: &request, with: headers)
        
        // Encode body to JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return completion(.failure(.encodingError))
        }
        
        perform(request, completion: completion)
    }
    
    // MARK: - PUT
    
    public func put(to url: URL,
                    body: Encodable,
                    headers: [String: String]? = nil,
                    queryItems: [URLQueryItem]? = nil,
                    completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: configureQueryParameters(for: url, with: queryItems))
        request.httpMethod = "PUT"
        configureHeaders(for: &request, with: headers)
        
        // Encode body to JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return completion(.failure(.encodingError))
        }
        
        perform(request, completion: completion)
    }
    
    // MARK: - DELETE
    
    public func delete(from url: URL,
                       headers: [String: String]? = nil,
                       queryItems: [URLQueryItem]? = nil,
                       completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: configureQueryParameters(for: url, with: queryItems))
        request.httpMethod = "DELETE"
        configureHeaders(for: &request, with: headers)
        
        perform(request, completion: completion)
    }
    
    // MARK: - Perfrom Request
    
    private func perform(_ request: URLRequest,
                         completion: @escaping @Sendable (Result<Data, NetworkError>) -> Void
    ) {
        urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                return completion(.failure(.unknown))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.serverError(statusCode: 404)))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // MARK: - Helper Methods
    
    private func configureHeaders(for request: inout URLRequest, with headers: [String: String]?) {
        var headers = headers ?? [:]
        
        // Default Content-Type
        if headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }
        
        // Add headers to request
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func configureQueryParameters(for url: URL, with queryItems: [URLQueryItem]?) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url ?? url
    }
}
