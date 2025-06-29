//
//  DependencyContainer.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import CredentialsValidator
import BrowseDomain
import NetworkClient
import LoginDomain
import SignUpDomain
import ImageDetailsDomain

@MainActor
final class DependencyContainer {
    
    // MARK: - Shared instances
    
    /// Shared instance of `CredentialsValidator` used for validating user credentials.
    lazy var credentialsValidator = CredentialsValidator()
    
    /// Shared instance of `NetworkClient` used for API requests.
    lazy var networkClient = NetworkClient()
    
    /// Shared instance of `MockLoginService` used for mocking LogIn network requests.
    lazy var loginService = MockLoginService(networkClient: networkClient)
    
    /// Shared instance of `MockSignUpService` used for mocking SignUp network requests.
    lazy var signUpService = MockSignUpService(networkClient: networkClient)
    
    /// Shared instance of `BrowseService` used for listing images from API.
    lazy var browseService = BrowseService(networkClient: networkClient, config: config)
    
    lazy var imageDetailsService = ImageDetailsService(networkManager: networkClient, config: config)
    lazy var imageDownloadService = ImageDownloadService()
    
    /// Shared instance of `UnsplashConfig` userd for configuration Unsplash API.
    lazy var config = UnsplashConfig(
        baseURL: Environment.baseURL,
        accessKey: Environment.apiKey
    )
}
