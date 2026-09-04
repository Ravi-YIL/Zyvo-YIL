//
//  PlaceMngmt_Model.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 28/01/25.
//

import Foundation

// MARK: - DataClass
struct PlaceMngmt_Model: Codable {
    let propertyId: Int?

    enum CodingKeys: String, CodingKey {
        case propertyId = "property_id"
    }
}

struct PropertyCreateData: Codable {
//    let propertyId: Int?
    let user_id: Int
    let space_type: String
    let property_size, maxGuestCount, bedroomCount, bathroomCount: Int
    let isInstantBook, hasSelfCheckin, allowsPets: Int
    let cancellationDuration: Int
    let title, description, parkingRules, hostRules: String
    let streetAddress, city, zipCode, country: String
    let state: String
    let latitude, longitude: Double
    let minBookingHours, hourlyRate, bulkDiscountHour, bulkDiscountRate: Int
    let cleaningFee: Int
    let availableMonth, availableDay, availableFrom, available_to: String
    let images, activities, amenities: [String]
    let addOns: [addonsData]

    enum CodingKeys: String, CodingKey {
//        case propertyId = "property_id"
        case user_id = "user_id"
        case space_type = "space_type"
        case property_size = "property_size"
        case maxGuestCount = "max_guest_count"
        case bedroomCount = "bedroom_count"
        case bathroomCount = "bathroom_count"
        case isInstantBook = "is_instant_book"
        case hasSelfCheckin = "has_self_checkin"
        case allowsPets = "allows_pets"
        case cancellationDuration = "cancellation_duration"
        case title, description
        case parkingRules = "parking_rules"
        case hostRules = "host_rules"
        case streetAddress = "street_address"
        case city
        case zipCode = "zip_code"
        case country, state, latitude, longitude
        case minBookingHours = "min_booking_hours"
        case hourlyRate = "hourly_rate"
        case bulkDiscountHour = "bulk_discount_hour"
        case bulkDiscountRate = "bulk_discount_rate"
        case cleaningFee = "cleaning_fee"
        case availableMonth = "available_month"
        case availableDay = "available_day"
        case availableFrom = "available_from"
        case available_to = "available_to"
        case images, activities, amenities
        case addOns = "add_ons"
    }
}
