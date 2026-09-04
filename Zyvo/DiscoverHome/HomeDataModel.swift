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
}

// MARK: - chatTokenModel
struct chatTokenModel: Codable {
    let token, identity: String?
}


