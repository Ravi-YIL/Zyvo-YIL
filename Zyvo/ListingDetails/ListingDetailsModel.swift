//
//  ListingDetailsModel.swift
//  Zyvo
//
//  Created by ravi on 24/04/2025.
//


// MARK: - DataClass
struct ListingDetailsModel: Codable {
    let host: Host?
    let aboutHost: AboutHost?
    let properties: [Property]?

    enum CodingKeys: String, CodingKey {
        case host
        case aboutHost = "about_host"
        case properties
    }
}

// MARK: - AboutHost
struct AboutHost: Codable {
    let hostProfession: [String]?
    let location: String?
    let language: [String]?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case hostProfession = "host_profession"
        case location, language, description
    }
}

// MARK: - Host
struct Host: Codable {
    let profilePicture, name: String?

    enum CodingKeys: String, CodingKey {
        case profilePicture = "profile_picture"
        case name
    }
}

// MARK: - Property
struct Property: Codable {
    let propertyID, hostID: Int?
    let hostName, title, hourlyRate: String?
    let isInstantBook: Int?
    let reviewsTotalRating: String?
    let reviewsTotalCount: AnyDataType?
    let latitude, longitude, distanceMiles, profileImage: String?
    let propertyImages: [String]?
    let host: HostDetail?
    
    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case hostID = "host_id"
        case hostName = "host_name"
        case title
        case hourlyRate = "hourly_rate"
        case isInstantBook = "is_instant_book"
        case reviewsTotalRating = "reviews_total_rating"
        case reviewsTotalCount = "reviews_total_count"
        case latitude, longitude
        case distanceMiles = "distance_miles"
        case profileImage = "profile_image"
        case propertyImages = "property_images"
        case host
    }
    
   
 
}

struct HostDetail:Codable{
    let profile_picture, name: String
}
// MARK: - Datum
struct hostReviewData: Codable {
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
struct AnyDataType: Codable {
    var value: String = ""

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

       
        if let stringValue = try? container.decode(String.self) {
            if let doubleValue = Double(stringValue) {
                if stringValue.contains(".") {
                    value = String(format: "%.2f", doubleValue)
                } else {
                    value = stringValue
                }
            } else {
                value = stringValue
            }
            return
            
        }
        if let intValue = try? container.decode(Int.self) {
            value = String(intValue)
            return
        }
        
        if let DoubleValue = try? container.decode(Double.self) {
            let roundedValue = String(format: "%.2f", DoubleValue)
            value = String(roundedValue)
            return
        }
      
        throw DecodingError.typeMismatch(
            AnyDataType.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected String or Int for FlexibleString"
            )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
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
