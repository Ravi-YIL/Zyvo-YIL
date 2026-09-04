//
//  NotificationModel.swift
//  Zyvo
//
//  Created by ravi on 27/02/25.

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let userID, notificationID: Int?
    let title: String?
    let createdAt: String?
    let data: BookingData?
    let type: String?
    let message: String
    let userType: String
    let isRead: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case notificationID = "notification_id"
        case title
        case createdAt = "created_at"
        case data, type, message
        case userType = "user_type"
        case isRead = "is_read"
    }
}

// MARK: - BookingData
struct BookingData: Codable {
    let bookingID: Int?
    let propertyID: String?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case propertyID = "property_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // booking_id is always Int?
        bookingID = try? container.decodeIfPresent(Int.self, forKey: .bookingID)

        // property_id can be Int or String — convert both to String
        if let intValue = try? container.decodeIfPresent(Int.self, forKey: .propertyID) {
            propertyID = String(intValue)
        } else if let stringValue = try? container.decodeIfPresent(String.self, forKey: .propertyID) {
            propertyID = stringValue
        } else {
            propertyID = nil
        }
    }
}

