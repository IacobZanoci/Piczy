//
//  MockImageDownloadService.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 29.06.2025.
//

import Foundation
import ImageDetailsDomain

final class MockImageDownloadService: ImageDownloadServiceProtocol {
    
    var shouldSucceed = true
    var mockFilePath: URL = URL(fileURLWithPath: "/mock/path/image.jpg")
    
    var mockError: ImageDetailsError?
    
    func downloadImage(from url: URL, completion: @escaping (Result<URL, ImageDetailsError>) -> Void) {
        if shouldSucceed {
            completion(.success(mockFilePath))
        } else {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(.networkTimeout))
            }
        }
    }
}
