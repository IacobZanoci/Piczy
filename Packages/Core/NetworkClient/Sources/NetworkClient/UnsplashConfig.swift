//
//  UnsplashConfig.swift
//  NetworkClient
//
//  Created by Iacob Zanoci on 30.05.2025.
//

public struct UnsplashConfig {
    
    public let baseURL: String
    public let accessKey: String
    
    public init(baseURL: String, accessKey: String) {
        self.baseURL = baseURL
        self.accessKey = accessKey
    }
}
