//
//  HomeDataModel.swift
//  Zyvo
//
//  Created by ravi on 30/01/25.

// MARK: - Datum
struct HomeDataModel: Codable {
    let distanceMiles: String?
    let hourlyRate, reviewCount: String?
    let isInWishlist: Int?
    let title, rating: String?
    let propertyID: Int?
    let longitude, latitude: String?
    let isInstantBook: Int?
    let images: [String]?
    let isStarHost: Bool?
    let hostName: String?
    let hostAddress: String?
    let hostProfileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case distanceMiles = "distance_miles"
        case hourlyRate = "hourly_rate"
        case reviewCount = "review_count"
        case isInWishlist = "is_in_wishlist"
        case title, rating
        case propertyID = "property_id"
        case longitude, latitude
        case isInstantBook = "is_instant_book"
        case images
        case isStarHost = "is_star_host"
        case hostName = "host_name"
        case hostAddress = "host_address"
        case hostProfileImageUrl = "host_profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let value = try? container.decode(String.self, forKey: .distanceMiles) {
            distanceMiles = value
        } else if let value = try? container.decode(Int.self, forKey: .distanceMiles) {
            distanceMiles = String(value)
        } else if let value = try? container.decode(Double.self, forKey: .distanceMiles) {
            distanceMiles = value.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(value))
                : String(value)
        } else {
            distanceMiles = nil
        }

        hourlyRate = try container.decodeIfPresent(String.self, forKey: .hourlyRate)
        reviewCount = try container.decodeIfPresent(String.self, forKey: .reviewCount)
        isInWishlist = try container.decodeIfPresent(Int.self, forKey: .isInWishlist)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
        propertyID = try container.decodeIfPresent(Int.self, forKey: .propertyID)
        longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        isInstantBook = try container.decodeIfPresent(Int.self, forKey: .isInstantBook)
        images = try container.decodeIfPresent([String].self, forKey: .images)
        isStarHost = try container.decodeIfPresent(Bool.self, forKey: .isStarHost)
        hostName = try container.decodeIfPresent(String.self, forKey: .hostName)
        hostAddress = try container.decodeIfPresent(String.self, forKey: .hostAddress)
        hostProfileImageUrl = try container.decodeIfPresent(String.self, forKey: .hostProfileImageUrl)
    }
}

// MARK: - chatTokenModel
struct chatTokenModel: Codable {
    let token, identity: String?
}

