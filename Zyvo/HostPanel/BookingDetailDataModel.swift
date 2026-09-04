//
//  BookingDetailDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 20/02/25.
//

import Foundation

struct BookingDetailDataModel: Codable {
    let propertyID, hostID, guestID: Int?
    let guestName, guestAvatar, guestRating, propertyTitle: String?
    let images: [String]?
    let reviewsTotalRating, reviewsTotalCount, distanceMiles, bookingHour: String?
    let bookingAmount, cleaningFee, serviceFee, tax: String?
    let addOnTotal, bookingTotalAmount, bookingStatus, discount: String?
    let hourOfExtension: Int?
    let amountOfExtension, bookingDate, bookingStartTime, bookingEndTime: String?
    let propertyDescription: String?
    let activities, amenities: [String]?
    let parkingRules, hostRules, address, latitude: String?
    let longitude: String?
    let extensionDetails: ExtensionDetails?

    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case hostID = "host_id"
        case guestID = "guest_id"
        case guestName = "guest_name"
        case guestAvatar = "guest_avatar"
        case guestRating = "guest_rating"
        case propertyTitle = "property_title"
        case images
        case reviewsTotalRating = "reviews_total_rating"
        case reviewsTotalCount = "reviews_total_count"
        case distanceMiles = "distance_miles"
        case bookingHour = "booking_hour"
        case bookingAmount = "booking_amount"
        case cleaningFee = "cleaning_fee"
        case serviceFee = "service_fee"
        case tax
        case addOnTotal = "add_on_total"
        case bookingTotalAmount = "booking_total_amount"
        case bookingStatus = "booking_status"
        case discount = "discount"
        case hourOfExtension = "hour_of_extension"
        case amountOfExtension = "amount_of_extension"
        case bookingDate = "booking_date"
        case bookingStartTime = "booking_start_time"
        case bookingEndTime = "booking_end_time"
        case propertyDescription = "property_description"
        case activities, amenities
        case parkingRules = "parking_rules"
        case hostRules = "host_rules"
        case address, latitude, longitude
        
        case extensionDetails = "extension_details"
    }
}

struct ExtensionDetails: Codable {
    let extensionAmount: String?
    let extensionHours: Int?
    let id: Int?
    let extensionStartTime: String?
    let extensionEndTime: String?
    let extensionDate: String?
    let extensionStatus: String?

    enum CodingKeys: String, CodingKey {
        case extensionAmount = "extension_amount"
        case extensionHours = "extension_hours"
        case id
        case extensionStartTime = "extension_start_time"
        case extensionEndTime = "extension_end_time"
        case extensionDate = "extension_date"
        case extensionStatus = "extension_status"
    }
}
