//
//  UnsplashPictureDetails.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import Foundation

public struct UnsplashPictureDetails : Decodable {
    
    // MARK: - Properties
    
    public let id: String
    public let createdAt: Date
    public let urls: Urls
    public let user: User
    public let exif: Exif?
    public let location: Location?
    
    // MARK: - Initializers
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        urls = try container.decode(Urls.self, forKey: .urls)
        user = try container.decode(User.self, forKey: .user)
        exif = try container.decode(Exif?.self, forKey: .exif)
        location = try container.decode(Location?.self, forKey: .location)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let createdAtString = try container.decode(String.self, forKey: .created_at)
        guard let createdAtDate = dateFormatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .created_at, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        
        createdAt = createdAtDate
    }
    
    // MARK: - Decoding Keys
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case created_at
        case urls
        case user
        case exif
        case location
    }
}
