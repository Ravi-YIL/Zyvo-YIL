//
//  EditPropertyViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/02/25.
//

import Foundation
// MARK: - TopLevel
struct GetPropertyModel: Codable {
    let propertyID, userID, hostID: Int?
    let title, spaceType: String?
    let propertySize, maxGuestCount, bedroomCount, bathroomCount: Int?
    let isInstantBook, hasSelfCheckin, allowsPets, cancellationDuration: Int?
    let streetAddress, city, state, country: String?
    let zipCode, latitude, longitude, minBookingHours: String?
    let hourlyRate,propertyDescription,parkingRules,hostRules: String?
    let bulkDiscountHour: Int?
    let bulkDiscountRate, cleaningFee, availableMonth, availableDay: String?
    let availableFrom, availableTo, fname, lname: String?
    let activities, amenities: [String]?
    let propertyImages: [PropertyImage]?
    let addOns: [addonsDataGet]?

    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case userID = "user_id"
        case hostID = "host_id"
        case title
        case spaceType = "space_type"
        case propertySize = "property_size"
        case maxGuestCount = "max_guest_count"
        case bedroomCount = "bedroom_count"
        case bathroomCount = "bathroom_count"
        case isInstantBook = "is_instant_book"
        case hasSelfCheckin = "has_self_checkin"
        case allowsPets = "allows_pets"
        case cancellationDuration = "cancellation_duration"
        case streetAddress = "street_address"
        case city, state, country
        case zipCode = "zip_code"
        case latitude, longitude
        case minBookingHours = "min_booking_hours"
        case hourlyRate = "hourly_rate"
        case bulkDiscountHour = "bulk_discount_hour"
        case bulkDiscountRate = "bulk_discount_rate"
        case cleaningFee = "cleaning_fee"
        case availableMonth = "available_month"
        case availableDay = "available_day"
        case availableFrom = "available_from"
        case availableTo = "available_to"
        case fname, lname
        case propertyImages = "property_images"
        case activities, amenities
        case addOns = "add_ons"
        case propertyDescription = "property_description"
        case parkingRules = "parking_rules"
        case hostRules = "host_rules"
    }
    
}
struct addonsDataGet:Codable{
    var name: String?
    var price: String?
}
