//
//  PropertyDetailsModel.swift
//  Zyvo
//
//  Created by ravi on 3/02/25.
//


// MARK: - DataClass

// MARK: - DataClass
struct PropertyDetailsModel: Codable {
    let reviews: [Review]?
    let address, hostProfileImage, parkingRules: String?
    let activities: [String]?
    let cancellationTime: Int?
    let reviewsTotalRating, propertyDescription, cleaningFee: String?
    let tax: Int?
    let isStarHost: Bool?
    let bulkDiscountRate: String?
    let addOns: [AddOn]?
    let addOnsP: [AddOn]?
    let hostedBy: String?
    let propertyID: Int?
    let reviewsTotalCount, hourlyRate: String?
    let isInWishlist: Int?
    let images, amenities: [String]?
    let isInstantBook: Int?
    let minBookingHours: String?
    let propertySize, bulkDiscountHour: Int?
    let latitude: String?
    let hostID: Int?
    let longitude, hostRules, propertyTitle, serviceFee: String?

    enum CodingKeys: String, CodingKey {
        case reviews, address
        case hostProfileImage = "host_profile_image"
        case parkingRules = "parking_rules"
        case activities
        case cancellationTime = "cancellation_time"
        case reviewsTotalRating = "reviews_total_rating"
        case tax
        case isStarHost = "is_star_host"
        case propertyDescription = "property_description"
        case cleaningFee = "cleaning_fee"
        case bulkDiscountRate = "bulk_discount_rate"
        case addOns = "selected_add_ons"
        case addOnsP = "add_ons"
        case hostedBy = "hosted_by"
        case propertyID = "property_id"
        case reviewsTotalCount = "reviews_total_count"
        case hourlyRate = "hourly_rate"
        case isInWishlist = "is_in_wishlist"
        case images, amenities
        case isInstantBook = "is_instant_book"
        case minBookingHours = "min_booking_hours"
        case propertySize = "property_size"
        case bulkDiscountHour = "bulk_discount_hour"
        case latitude
        case hostID = "host_id"
        case longitude
        case hostRules = "host_rules"
        case propertyTitle = "property_title"
        case serviceFee = "service_fee"
    }
}

struct AddOn: Codable {
    let price: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case price
        case name
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)

            // ✅ Handle price as either String, Double, or Int
            if let priceString = try? container.decode(String.self, forKey: .price) {
                price = priceString
            } else if let priceDouble = try? container.decode(Double.self, forKey: .price) {
                price = String(priceDouble)
            } else if let priceInt = try? container.decode(Int.self, forKey: .price) {
                price = String(priceInt)
            } else {
                throw DecodingError.typeMismatch(
                    String.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected price to be a String, Int, or Double"
                    )
                )
            }
        }

}


// MARK: - Review
struct Review: Codable {
    let reviewDate, reviewMessage, reviewRating, reviewerName: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case reviewDate = "review_date"
        case reviewMessage = "review_message"
        case reviewRating = "review_rating"
        case reviewerName = "reviewer_name"
        case profileImage = "profile_image"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalPages, total, perPage, count: Int?
    let currentPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case total
        case perPage = "per_page"
        case count
        case currentPage = "current_page"
    }
}

//// MARK: - Datum
struct FilterModel: Codable {
    let reviewerName: String?
    let profileImage: String?
    let reviewRating, reviewMessage, reviewDate: String?

    enum CodingKeys: String, CodingKey {
        case reviewerName = "reviewer_name"
        case profileImage = "profile_image"
        case reviewRating = "review_rating"
        case reviewMessage = "review_message"
        case reviewDate = "review_date"
    }
}

//// MARK: - Datum
//struct FilterModel: Codable {
//    let reviewerName, profileImage, reviewRating, reviewMessage: String?
//    let reviewDate: String?
//
//    enum CodingKeys: String, CodingKey {
//        case reviewerName = "reviewer_name"
//        case profileImage = "profile_image"
//        case reviewRating = "review_rating"
//        case reviewMessage = "review_message"
//        case reviewDate = "review_date"
//    }
//}

// MARK: - Pagination
//struct Pagination: Codable {
//    let total, count, perPage, currentPage: Int?
//    let totalPages: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case total, count
//        case perPage = "per_page"
//        case currentPage = "current_page"
//        case totalPages = "total_pages"
//    }
//}



//// MARK: - Pagination
//struct Pagination: Codable {
//    let total, count, perPage, currentPage: Int?
//    let totalPages: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case total, count
//        case perPage = "per_page"
//        case currentPage = "current_page"
//        case totalPages = "total_pages"
//    }
//}
