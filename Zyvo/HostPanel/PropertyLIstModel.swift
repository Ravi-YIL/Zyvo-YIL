//
//  PropertyLIstModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 30/01/25.
//

import Foundation

// MARK: - TopLevelElement
struct PropertyListModel: Codable {
    let propertyID, hostID: Int?
    let title, hourlyRate: String?
    let isInstantBook: Int?
    let fname, lname, address: String?
    let latitude, longitude: String?
    let propertyReviewCount: String?
    let propertyRating: String  // Change from Double to String
    let propertyImages: [String]?
    let profileImage: String?
    let distanceMiles: String?
    
    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case hostID = "host_id"
        case title
        case hourlyRate = "hourly_rate"
        case isInstantBook = "is_instant_book"
        case fname, lname, address, latitude, longitude
        case propertyReviewCount = "property_review_count"
        case propertyRating = "property_rating"
        case propertyImages = "property_images"
        case profileImage = "profile_image"
        case distanceMiles = "distance_miles"
    }
}


struct PropertyImage: Codable {
    let id: Int?
    let image_url: String?
}
