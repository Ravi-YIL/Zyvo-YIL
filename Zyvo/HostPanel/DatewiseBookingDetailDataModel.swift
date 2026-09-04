//
//  File.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 25/02/25.
//

import Foundation
// MARK: - TopLevel
struct DatewiseBookingDetailDataModel: Codable {
    let propertyID: Int?
    let propertyTitle, propertyStatus, propertyImage, reviewsTotalRating: String?
    let reviewsTotalCount: String?
    let distanceMiles: String?
    let bookings: [BookingAPIModel]?

    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case propertyTitle = "property_title"
        case propertyStatus = "property_status"
        case propertyImage = "property_image"
        case reviewsTotalRating = "reviews_total_rating"
        case reviewsTotalCount = "reviews_total_count"
        case distanceMiles = "distance_miles"
        case bookings
    }
}

// MARK: - Booking
struct BookingSlots: Codable {
    let bookingID: Int?
    let guestName, bookingStatus, bookingDate, bookingStartEnd: String?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case guestName = "guest_name"
        case bookingStatus = "booking_status"
        case bookingDate = "booking_date"
        case bookingStartEnd = "booking_start_end"
    }
}

struct SlotCustomDataModel{
    var date: String?
    var slots: [slots]?
}

struct slots{
    var bookingID: Int?
    var guestName: String?
    var bookingStatus: String?
    var bookingDate: String?
    var bookingStart_EndTime: String?
}
