//
//  WishlistDataModel.swift
//  Zyvo
//
//  Created by ravi on 3/02/25.
//

// MARK: - WishlistData
struct WishlistDataModel: Codable {
    let wishlistID: Int?
    let wishlistName: String?
    let itemsInWishlist: Int?
    let lastSavedPropertyID: Int?
    let lastSavedPropertyImage: String?

    enum CodingKeys: String, CodingKey {
        case wishlistID = "wishlist_id"
        case wishlistName = "wishlist_name"
        case itemsInWishlist = "items_in_wishlist"
        case lastSavedPropertyID = "last_saved_property_id"
        case lastSavedPropertyImage = "last_saved_property_image"
    }
}
