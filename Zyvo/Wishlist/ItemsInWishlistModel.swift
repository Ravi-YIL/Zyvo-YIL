//
//  ItemsInWishlistModel.swift
//  Zyvo
//
//  Created by ravi on 4/02/25.
//


// MARK: - Datum
struct ItemsInWishlistModel: Codable {
    let wishlistItemID, propertyID: Int?
    let images: [String]?
    let title, hourlyRate: String?
    let isInstantBook, isInWishlist: Int?
    let rating: String?
    let reviewCount: String?
    let location_in_miles : String?
    let hostName: String?
    let hostAddress: String?
    let hostProfileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case wishlistItemID = "wishlist_item_id"
        case propertyID = "property_id"
        case images, title
        case hourlyRate = "hourly_rate"
        case isInstantBook = "is_instant_book"
        case isInWishlist = "is_in_wishlist"
        case rating
        case reviewCount = "review_count"
        case location_in_miles = "location_in_miles"
        case hostName = "host_name"
        case hostAddress = "host_location"
        case hostProfileImageUrl = "host_profile_image"
    }
}
