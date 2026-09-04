//
//  HomeDataFilterModel.swift
//  Zyvo
//
//  Created by ravi on 6/03/25.
//


// MARK: - HomeDataFilterModel
struct HomeDataFilterModel: Codable {
    let title, reviewCount: String?
    let isInstantBook: Int?
    let distanceMiles, hourlyRate, latitude: String?
    let propertyID: Int?
    let isInWishlist: String?
    let longitude: String?
    let images: [String]?
    let rating: String?

    enum CodingKeys: String, CodingKey {
        case title
        case reviewCount = "review_count"
        case isInstantBook = "is_instant_book"
        case distanceMiles = "distance_miles"
        case hourlyRate = "hourly_rate"
        case latitude
        case propertyID = "property_id"
        case isInWishlist = "is_in_wishlist"
        case longitude, images, rating
    }
}

// MARK: - DataClass
struct MinMaxRangeModel: Codable {
    let minimumPrice, maximumPrice: String?

    enum CodingKeys: String, CodingKey {
        case minimumPrice = "minimum_price"
        case maximumPrice = "maximum_price"
    }

    init(minimumPrice: String? = nil, maximumPrice: String? = nil) {
        self.minimumPrice = minimumPrice
        self.maximumPrice = maximumPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        func decodeStringOrNumber(forKey key: CodingKeys) -> String? {
            if let stringValue = try? container.decode(String.self, forKey: key) {
                return stringValue
            } else if let intValue = try? container.decode(Int.self, forKey: key) {
                return String(intValue)
            } else if let doubleValue = try? container.decode(Double.self, forKey: key) {
                if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                    return String(Int(doubleValue))
                } else {
                    return String(doubleValue)
                }
            }
            return nil
        }

        self.minimumPrice = decodeStringOrNumber(forKey: .minimumPrice)
        self.maximumPrice = decodeStringOrNumber(forKey: .maximumPrice)
    }
}

