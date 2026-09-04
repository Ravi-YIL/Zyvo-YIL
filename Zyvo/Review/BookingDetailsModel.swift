//
//  BookingDetailsModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.


// MARK: - DataClass


// MARK: - DataClass
struct BookingDetailsModel: Codable {
    let longitude: String?
    let bookingID: Int?
    let latitude: String?
    let charges: Charges?
    let hostProfileImage, totalRating, propertyName: String?
    let guestID: Int?
    let firstPropertyImage, status: String?
    let propertyImages: [String]?
    let rating: Double?
    let refundPolicies: [String]?
    let propertyID: Int?
    let location: String?
    let hostID: Int?
    let isInWishlist: Int?
    let hostName: String?
    let parkingRules: [String]?
    let distanceMiles: String?
    let bookingDetail: BookingDetail?
    let amenities, activities: [String]?
    let reviews: [ReviewData]?
    let addOns: [AddOn]?
    let hostRules: [String]?

    enum CodingKeys: String, CodingKey {
        case longitude
        case bookingID = "booking_id"
        case latitude, charges
        case hostProfileImage = "host_profile_image"
        case totalRating = "total_rating"
        case propertyName = "property_name"
        case guestID = "guest_id"
        case firstPropertyImage = "first_property_image"
        case status
        case propertyImages = "property_images"
        case rating
        case refundPolicies = "refund_policies"
        case propertyID = "property_id"
        case location
        case hostID = "host_id"
        case isInWishlist = "is_in_wishlist"
        case hostName = "host_name"
        case parkingRules = "parking_rules"
        case distanceMiles = "distance_miles"
        case bookingDetail = "booking_detail"
        case amenities, activities, reviews
        case addOns = "add_ons"
        case hostRules = "host_rules"
    }
}

// MARK: - BookingDetail
struct BookingDetail: Codable {
    let date, startEndTime, time: String?

    enum CodingKeys: String, CodingKey {
        case date
        case startEndTime = "start_end_time"
        case time
    }
}

// MARK: - Charges
struct Charges: Codable {
    let zyvoServiceFee: Double?
    let bookingAmount: Int?
    let minBookingHours: String?
    let discount: Double?
    let hourlyRate, bulkDiscountRate: String?
    let bookingHours: Int?
    let cleaningFee, taxes: Double?
    let total: Double?
    let addOn, bulkDiscountHours: Int?

    enum CodingKeys: String, CodingKey {
        case zyvoServiceFee = "zyvo_service_fee"
        case bookingAmount = "booking_amount"
        case minBookingHours = "min_booking_hours"
        case discount
        case hourlyRate = "hourly_rate"
        case bulkDiscountRate = "bulk_discount_rate"
        case bookingHours = "booking_hours"
        case cleaningFee = "cleaning_fee"
        case taxes
        case addOn = "add-on"
        case total
        case bulkDiscountHours = "bulk_discount_hours"
    }
}

// MARK: - Review
struct ReviewData: Codable {
    let rating: Double?
    let name, date: String?
    let image: String?
    let comment: String?
}


// MARK: - DataClass
struct JoinChanelModel: Codable {
    let senderID, senderName, senderAvatar, receiverID: String?
    let receiverName, receiverAvatar, groupChannel: String?

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case senderName = "sender_name"
        case senderAvatar = "sender_avatar"
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case receiverAvatar = "receiver_avatar"
        case groupChannel = "group_channel"
    }
}
//struct BookingDetailsModel: Codable {
//    let hostID: Int?
//    let rating: Double?
//    let bookingID: Int?
//    let propertyName, hostProfileImage: String?
//    let reviews: [ReviewData]?
//    let location, latitude: String?
//    let bookingDetail: BookingDetail?
//    let distanceMiles: String?
//    let propertyID: Int?
//    let totalRating, status, hostName, firstPropertyImage: String?
//    let activities, hostRules: [String]?
//    let charges: Charges?
//    let longitude: String?
//    let parkingRules, propertyImages: [String]?
//    let refundPolicies: [String]?
//    let addOns: [AddOn]?
//    let amenities: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case hostID = "host_id"
//        case rating
//        case bookingID = "booking_id"
//        case propertyName = "property_name"
//        case hostProfileImage = "host_profile_image"
//        case reviews, location, latitude
//        case bookingDetail = "booking_detail"
//        case distanceMiles = "distance_miles"
//        case propertyID = "property_id"
//        case totalRating = "total_rating"
//        case status
//        case hostName = "host_name"
//        case firstPropertyImage = "first_property_image"
//        case activities
//        case hostRules = "host_rules"
//        case charges, longitude
//        case parkingRules = "parking_rules"
//        case propertyImages = "property_images"
//        case refundPolicies = "refund_policies"
//        case addOns = "add_ons"
//        case amenities
//    }
//}

// MARK: - AddOn
//struct AddOn: Codable {
//    let name, price: String?
//}

// MARK: - BookingDetail
//struct BookingDetail: Codable {
//    let startEndTime, date, time: String?
//
//    enum CodingKeys: String, CodingKey {
//        case startEndTime = "start_end_time"
//        case date, time
//    }
//}

// MARK: - Charges


// MARK: - Charges

//struct Charges: Codable {
//    let bookingAmount: Double?
//    let zyvoServiceFee: Double?
//    let hourlyRate: String?
//    let total: Double?
//    let bulkDiscountRate: String?
//    let cleaningFee: Double?
//    let addOn: Double?
//    let bookingHours: Int?
//    let taxes: Double?
//    let bulkDiscountHours: Int?
//    let minBookingHours: String?
//    let discount: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case bookingAmount = "booking_amount"
//        case zyvoServiceFee = "zyvo_service_fee"
//        case hourlyRate = "hourly_rate"
//        case total
//        case bulkDiscountRate = "bulk_discount_rate"
//        case cleaningFee = "cleaning_fee"
//        case addOn = "add-on"
//        case bookingHours = "booking_hours"
//        case taxes
//        case bulkDiscountHours = "bulk_discount_hours"
//        case minBookingHours = "min_booking_hours"
//        case discount
//    }
//}

//struct Charges: Codable {
//    let cleaningFee : Int?
//    let total: Double?
//    let hourlyRate: String?
//    let discount, bulkDiscountHours, bookingAmount, addOn: Int?
//    let zyvoServiceFee: Double?
//    let minBookingHours: String?
//    let bookingHours: Int?
//    let bulkDiscountRate: String?
//    let taxes: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case cleaningFee = "cleaning_fee"
//        case total
//        case hourlyRate = "hourly_rate"
//        case discount
//        case bulkDiscountHours = "bulk_discount_hours"
//        case bookingAmount = "booking_amount"
//        case addOn = "add-on"
//        case zyvoServiceFee = "zyvo_service_fee"
//        case minBookingHours = "min_booking_hours"
//        case bookingHours = "booking_hours"
//        case bulkDiscountRate = "bulk_discount_rate"
//        case taxes
//    }
//}
//struct Charges: Codable {
//    let bookingAmount: Int?
//    let addOn: Int?
//    let cleaningFee: String?
//    let bookingHours: Int?
//    let hourlyRate, bulkDiscountRate, minBookingHours, taxes: String?
//    let total: String?
//    let bulkDiscountHours: Int?
//    let zyvoServiceFee: String?
//
//    enum CodingKeys: String, CodingKey {
//        case bookingAmount = "booking_amount"
//        case addOn = "add-on"
//        case cleaningFee = "cleaning_fee"
//        case bookingHours = "booking_hours"
//        case hourlyRate = "hourly_rate"
//        case bulkDiscountRate = "bulk_discount_rate"
//        case minBookingHours = "min_booking_hours"
//        case taxes, total
//        case bulkDiscountHours = "bulk_discount_hours"
//        case zyvoServiceFee = "zyvo_service_fee"
//    }
//    
//    
//}

//// MARK: - Review
//struct ReviewData: Codable {
//    let comment: String?
//    let date: String?
//    let rating: Double?
//    let name: String?
//    let image: String?
//}


//// MARK: - DataClass
//struct BookingDetailsModel: Codable {
//    let status: String?
//    let charges: Charges?
//    let parkingRules: [String]?
//    let reviews: [Review]?
//    let propertyName: String?
//    let hostID: Int?
//    let distanceMiles, firstPropertyImage: String?
//    let bookingDetail: BookingDetail?
//    let totalRating, latitude: String?
//    let propertyImages: [String]?
//    let propertyID: Int?
//    let longitude: String?
//    let addOns: [AddOn]?
//    let rating: Int?
//    let hostRules: [String]?
//    let refundPolicies: [String]?
//    let location, hostProfileImage: String?
//    let bookingID: Int?
//    let hostName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case status, charges
//        case parkingRules = "parking_rules"
//        case reviews
//        case propertyName = "property_name"
//        case hostID = "host_id"
//        case distanceMiles = "distance_miles"
//        case firstPropertyImage = "first_property_image"
//        case bookingDetail = "booking_detail"
//        case totalRating = "total_rating"
//        case latitude
//        case propertyImages = "property_images"
//        case propertyID = "property_id"
//        case longitude
//        case addOns = "add_ons"
//        case rating
//        case hostRules = "host_rules"
//        case refundPolicies = "refund_policies"
//        case location
//        case hostProfileImage = "host_profile_image"
//        case bookingID = "booking_id"
//        case hostName = "host_name"
//    }
//    
//}
//
//// MARK: - BookingDetail
//struct BookingDetail: Codable {
//    let date, startEndTime, time: String?
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case startEndTime = "start_end_time"
//        case time
//    }
//}
//
//// MARK: - Charges
//struct Charges: Codable {
//    let cleaningFee: String?
//    let addOn: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case cleaningFee = "cleaning_fee"
//        case addOn = "add-on"
//    }
//}
//
//// MARK: - Review
////struct Review: Codable {
////    let rating: Int?
////    let image: String?
////    let comment: String?
////    let date, name: String?
////}
//
////
//
////struct BookingDetailsModel: Codable {
////    let includedInBooking: [String]?
////    let charges: Charges?
////    let propertyName: String?
////    let distance: String?
////    let hostRule: String?
////    let addOns: [String]?
////    let hostID: Int?
////    let refundPolicies: String?
////    let hostName: String?
////    let location: String?
////    let parking: String?
////    let bookingID: Int?
////    let bookingDetail: BookingDetail?
////    let latitude: String?
////    let totalRating: String?
////    let reviews: [Review]?
////    let status: String?
////    let longitude: String?
////    let rating: Double? // Will be rounded in custom decoding
////
////    enum CodingKeys: String, CodingKey {
////        case includedInBooking = "included_in_booking"
////        case charges
////        case propertyName = "property_name"
////        case distance
////        case hostRule = "host_rule"
////        case addOns = "add-ons"
////        case hostID = "host_id"
////        case refundPolicies = "refund_policies"
////        case hostName = "host_name"
////        case location
////        case parking
////        case bookingID = "booking_id"
////        case bookingDetail = "booking_detail"
////        case latitude
////        case totalRating = "total_rating"
////        case reviews
////        case status
////        case longitude
////        case rating
////    }
////
////    init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////
////        includedInBooking = try? container.decode([String].self, forKey: .includedInBooking)
////        charges = try? container.decode(Charges.self, forKey: .charges)
////        propertyName = try? container.decode(String.self, forKey: .propertyName)
////        distance = try? container.decode(String.self, forKey: .distance)
////        hostRule = try? container.decode(String.self, forKey: .hostRule)
////        addOns = try? container.decode([String].self, forKey: .addOns)
////        hostID = try? container.decode(Int.self, forKey: .hostID)
////        refundPolicies = try? container.decode(String.self, forKey: .refundPolicies)
////        hostName = try? container.decode(String.self, forKey: .hostName)
////        location = try? container.decode(String.self, forKey: .location)
////        parking = try? container.decode(String.self, forKey: .parking)
////        bookingID = try? container.decode(Int.self, forKey: .bookingID)
////        bookingDetail = try? container.decode(BookingDetail.self, forKey: .bookingDetail)
////        latitude = try? container.decode(String.self, forKey: .latitude)
////        totalRating = try? container.decode(String.self, forKey: .totalRating)
////        reviews = try? container.decode([Review].self, forKey: .reviews)
////        status = try? container.decode(String.self, forKey: .status)
////        longitude = try? container.decode(String.self, forKey: .longitude)
////
////        // Handle `rating` with rounding to avoid errors
////        if let rawRating = try? container.decode(Double.self, forKey: .rating) {
////            rating = Double(String(format: "%.2f", rawRating)) // Round to 2 decimal places
////        } else {
////            rating = nil
////        }
////    }
////}
////
////struct Charges: Codable {
////    let taxes: String?
////    let total: String?
////    let cleaningFee: String?
////    let addOn: String?
////    let serviceFee: String?
////    let timeCharge: String?
////
////    enum CodingKeys: String, CodingKey {
////        case taxes
////        case total
////        case cleaningFee = "cleaning_fee"
////        case addOn = "add-on"
////        case serviceFee = "service_fee"
////        case timeCharge = "time_charge"
////    }
////}
////
////struct BookingDetail: Codable {
////    let startEndTime: String?
////    let time: String?
////    let date: String?
////
////    enum CodingKeys: String, CodingKey {
////        case startEndTime = "start_end_time"
////        case time
////        case date
////    }
////}
