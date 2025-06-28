//
//  ImageDownloadService.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation
import UIKit

public final class ImageDownloadService: ImageDownloadServiceProtocol {
    
    // MARK: - Initializers
    
    public init() {}
    
    // MARK: - Methods
    
    public func downloadImage(from url: URL, completion: @escaping (Result<URL, ImageDetailsError>) -> Void) {
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
                      let _ = UIImage(data: data) else {
                    completion(.failure(.downloadFailed))
                    return
                }
                
                let fileExtension: String
                switch contentType.lowercased() {
                case "image/jpeg", "image/jpg":
                    fileExtension = "jpg"
                case "image/png":
                    fileExtension = "png"
                default:
                    fileExtension = "jpg"
                }
                
                let fileManager = FileManager.default
                let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let fileURL = directory.appendingPathComponent(UUID().uuidString + "." + fileExtension)
                
                try data.write(to: fileURL)
                completion(.success(fileURL))
            } catch {
                print("Image download error:", error)
                completion(.failure(.downloadFailed))
            }
        }
    }
}
