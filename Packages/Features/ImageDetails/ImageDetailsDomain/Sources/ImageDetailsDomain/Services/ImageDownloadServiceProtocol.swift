//
//  ImageDownloadServiceProtocol.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation

@MainActor
public protocol ImageDownloadServiceProtocol {
    
    func downloadImage(from url: URL, completion: @escaping (Result<URL, ImageDetailsError>) -> Void)
}
