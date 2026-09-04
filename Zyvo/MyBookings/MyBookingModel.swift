//
//  MyBookingModel.swift
//  Zyvo
//
//  Created by ravi on 12/02/25.
//

// MARK: - Datum
struct MyBookingModel: Codable {
    let bookingID: Int?
    let propertyName, propertyImage: String?
    let propertyID: Int?
    let bookingStatus, bookingDate: String?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case propertyName = "property_name"
        case propertyImage = "property_image"
        case propertyID = "property_id"
        case bookingStatus = "booking_status"
        case bookingDate = "booking_date"
    }
}
