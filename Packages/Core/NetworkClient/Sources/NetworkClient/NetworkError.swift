//
//  NetworkError.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation

public enum NetworkError: Error, Equatable {
    
    case invalidURL
    case encodingError
    case decodingError
    case serverError(statusCode: Int)
    case noData
    case invalidCredentials
    case emailAlreadyExists
    case unknown
}
