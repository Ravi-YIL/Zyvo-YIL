//
//  UserBookingModel.swift
//  Zyvo
//
//  Created by ravi on 13/03/25.
//



// MARK: - DataClass
struct UserBookingModel: Codable {
    let bookings: [UserBooking]?
    let properties: [UserProperty]?
}

// MARK: - Booking
struct UserBooking: Codable {
    let bookingEnd, finalBookingEnd, serviceFee, totalAmount: String?
    let bookingAmount, discountPercent: String?
    let isHostStar: Bool?
    let bookingID, hostUserID: Int?
    let selectedAddOns: [AddOn]?
    let bookingHours, totalAddonPrice: Int?
    let bookingHourlyRate, tax, bookingStart, paymentID: String?
    let propertyID: Int?
    let status: String?
    let extensionHours: Int?
    let cleaningFee, bookingExtensionAmount, bookingDate: String?
    let guestUserID: Int?

    enum CodingKeys: String, CodingKey {
        case bookingEnd = "booking_end"
        case finalBookingEnd = "final_booking_end"
        case serviceFee = "service_fee"
        case totalAmount = "total_amount"
        case bookingAmount = "booking_amount"
        case discountPercent = "discount_percent"
        case isHostStar = "is_star_host"
        case bookingID = "booking_id"
        case hostUserID = "host_user_id"
        case selectedAddOns = "selected_add_ons"
        case bookingHours = "booking_hours"
        case totalAddonPrice = "total_addon_price"
        case bookingHourlyRate = "booking_hourly_rate"
        case tax
        case bookingStart = "booking_start"
        case paymentID = "payment_id"
        case propertyID = "property_id"
        case status
        case extensionHours = "extension_hours"
        case cleaningFee = "cleaning_fee"
        case bookingExtensionAmount = "booking_extension_amount"
        case bookingDate = "booking_date"
        case guestUserID = "guest_user_id"
    }
}

// MARK: - Property
struct UserProperty: Codable {
    let propertyTitle, reviewsTotalRating, hostProfileImage: String?
    let amenities: [String]?
    let bulkDiscountHour: Int?
    let images: [String]?
    let latitude, longitude, hostedBy: String?
    let addOns: [AddOn]?
    let reviews: [Review]?
    let propertyID, isInstantBook: Int?
    let propertyDescription: String?
    let propertySize: Int?
    let activities: [String]?
    let tax, address: String?
    let isInWishlist: Int?
    let cleaningFee, reviewsTotalCount, serviceFee, minBookingHours: String?
    let hostID: Int?
    let hostRules, bulkDiscountRate, hourlyRate, parkingRules: String?

    enum CodingKeys: String, CodingKey {
        case propertyTitle = "property_title"
        case reviewsTotalRating = "reviews_total_rating"
        case hostProfileImage = "host_profile_image"
        case amenities
        case bulkDiscountHour = "bulk_discount_hour"
        case images, latitude, longitude
        case hostedBy = "hosted_by"
        case addOns = "add_ons"
        case reviews
        case propertyID = "property_id"
        case isInstantBook = "is_instant_book"
        case propertyDescription = "property_description"
        case propertySize = "property_size"
        case activities, tax, address
        case isInWishlist = "is_in_wishlist"
        case cleaningFee = "cleaning_fee"
        case reviewsTotalCount = "reviews_total_count"
        case serviceFee = "service_fee"
        case minBookingHours = "min_booking_hours"
        case hostID = "host_id"
        case hostRules = "host_rules"
        case bulkDiscountRate = "bulk_discount_rate"
        case hourlyRate = "hourly_rate"
        case parkingRules = "parking_rules"
    }
}


//// MARK: - AddOn
//struct AddOn: Codable {
//    let name, price: String
//}


//// MARK: - DataClass
//struct UserBookingModel: Codable {
//    let bookings: [UserBooking]?
//    let properties: [UserProperty]?
//}
//
//// MARK: - Booking
//struct UserBooking: Codable {
//    let serviceFee, totalAmount, bookingEnd: String?
//    let propertyID: Int?
//    let bookingStart: String?
//    let bookingExtensionAmount: String?
//    let bookingDate: String?
//    let bookingHours: Int?
//    let status, paymentID, finalBookingEnd: String?
//    let hostUserID, guestUserID: Int?
//    let cleaningFee, bookingHourlyRate: String?
//    let selectedAddOns: [SelectedAddOn]?
//    let discountPercent, tax: String?
//    let totalAddonPrice: Int?
//    let extensionHours: String?
//    let bookingAmount: String?
//    let bookingID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case serviceFee = "service_fee"
//        case totalAmount = "total_amount"
//        case bookingEnd = "booking_end"
//        case propertyID = "property_id"
//        case bookingStart = "booking_start"
//        case bookingExtensionAmount = "booking_extension_amount"
//        case bookingDate = "booking_date"
//        case bookingHours = "booking_hours"
//        case status
//        case paymentID = "payment_id"
//        case finalBookingEnd = "final_booking_end"
//        case hostUserID = "host_user_id"
//        case guestUserID = "guest_user_id"
//        case cleaningFee = "cleaning_fee"
//        case bookingHourlyRate = "booking_hourly_rate"
//        case selectedAddOns = "selected_add_ons"
//        case discountPercent = "discount_percent"
//        case tax
//        case totalAddonPrice = "total_addon_price"
//        case extensionHours = "extension_hours"
//        case bookingAmount = "booking_amount"
//        case bookingID = "booking_id"
//    }
//}
//
//// MARK: - SelectedAddOn
//struct SelectedAddOn: Codable {
//    let price: Int?
//    let name: String?
//}
//
//// MARK: - Property
//struct UserProperty: Codable {
//    let reviewsTotalCount: String?
//    let addOns: [AddOn]?
//    let hostRules: String?
//    let propertySize, isInWishlist, isInstantBook, hostID: Int?
//    let bulkDiscountHour: Int?
//    let hostedBy, latitude, cleaningFee, hostProfileImage: String?
//    let minBookingHours, hourlyRate: String?
//    let reviews: [String]?
//    let propertyDescription, tax, bulkDiscountRate, propertyTitle: String?
//    let amenities: [String]?
//    let propertyID: Int?
//    let parkingRules: String?
//    let images: [String]?
//    let serviceFee, reviewsTotalRating, address, longitude: String?
//    let activities: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case reviewsTotalCount = "reviews_total_count"
//        case addOns = "add_ons"
//        case hostRules = "host_rules"
//        case propertySize = "property_size"
//        case isInWishlist = "is_in_wishlist"
//        case isInstantBook = "is_instant_book"
//        case hostID = "host_id"
//        case bulkDiscountHour = "bulk_discount_hour"
//        case hostedBy = "hosted_by"
//        case latitude
//        case cleaningFee = "cleaning_fee"
//        case hostProfileImage = "host_profile_image"
//        case minBookingHours = "min_booking_hours"
//        case hourlyRate = "hourly_rate"
//        case reviews
//        case propertyDescription = "property_description"
//        case tax
//        case bulkDiscountRate = "bulk_discount_rate"
//        case propertyTitle = "property_title"
//        case amenities
//        case propertyID = "property_id"
//        case parkingRules = "parking_rules"
//        case images
//        case serviceFee = "service_fee"
//        case reviewsTotalRating = "reviews_total_rating"
//        case address, longitude, activities
//    }
//}
//
