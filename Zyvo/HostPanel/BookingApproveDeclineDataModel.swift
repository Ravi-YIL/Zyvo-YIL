//
//  File.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 25/03/25.
//

import Foundation
// MARK: - DataClass
struct BookingDataGet: Codable {
    let booking: H_BookingDataGet?
}

// MARK: - Booking
struct H_BookingDataGet: Codable {
    let id: Int?
    let paymentID: String?
    let bookingHours: Int?
    let createdAt: String?
    let statusUpdatedAt: String?
    let guestID: Int?
    let extensionHours: String?
    let propertyID: Int?
    let addons: [addonsData]?
    let updatedAt, bookingAmount, bookingDate: String?
    let hostID, guestUserID: Int?
    let status: String?
    let deletedAt: String?
    let cleaningFee: String?
    let bookingExtensionAmount, hourlyRate: String?
    let bookingEnd, totalAmount, tax: String?
    let declinedReason: String?
    let isGuestRead: Int?
    let serviceFee, bookingStart: String?
    let hostUserID: Int?
    let discountAmount: String?
    let hostMessage: String?
    let isFlexible: Int?
    let discountPercentage: String?
    let isHostRead: Int?
    let hostEarning: String?
    let finalBookingEnd: String?

    enum CodingKeys: String, CodingKey {
        case id
        case paymentID = "payment_id"
        case bookingHours = "booking_hours"
        case createdAt = "created_at"
        case statusUpdatedAt = "status_updated_at"
        case guestID = "guest_id"
        case extensionHours = "extension_hours"
        case propertyID = "property_id"
        case addons
        case updatedAt = "updated_at"
        case bookingAmount = "booking_amount"
        case bookingDate = "booking_date"
        case hostID = "host_id"
        case guestUserID = "guest_user_id"
        case status
        case deletedAt = "deleted_at"
        case cleaningFee = "cleaning_fee"
        case bookingExtensionAmount = "booking_extension_amount"
        case hourlyRate = "hourly_rate"
        case bookingEnd = "booking_end"
        case totalAmount = "total_amount"
        case tax
        case declinedReason = "declined_reason"
        case isGuestRead = "is_guest_read"
        case serviceFee = "service_fee"
        case bookingStart = "booking_start"
        case hostUserID = "host_user_id"
        case discountAmount = "discount_amount"
        case hostMessage = "host_message"
        case isFlexible = "is_flexible"
        case discountPercentage = "discount_percentage"
        case isHostRead = "is_host_read"
        case hostEarning = "host_earning"
        case finalBookingEnd = "final_booking_end"
    }
}
