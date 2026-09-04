//
//  BookingModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.
//


struct BookingModel: Codable {
    let booking: Booking?
    let startEndTime: String? // Matches "start_end_time" in JSON

    enum CodingKeys: String, CodingKey {
        case booking
        case startEndTime = "start_end_time"
    }
}

struct Booking: Codable {
    let tax: String?
    let bookingStart: String?
    let bookingAmount: String?
    let totalAmount: String?
    let propertyID: String?
    let bookingEnd: String?
    let cleaningFee: String?
    let guestUserID: String?
    let id: Int?
    let bookingDate: String?
    let updatedAt: String?
    let hostUserID: Int?
    let serviceFee: String?
    let createdAt: String?
    let addons: String?
    let hostID: Int?
    let guestID: Int?
    let bookingHours: Int?

    enum CodingKeys: String, CodingKey {
        case tax
        case bookingStart = "booking_start"
        case bookingAmount = "booking_amount"
        case totalAmount = "total_amount"
        case propertyID = "property_id"
        case bookingEnd = "booking_end"
        case cleaningFee = "cleaning_fee"
        case guestUserID = "guest_user_id"
        case id
        case bookingDate = "booking_date"
        case updatedAt = "updated_at"
        case hostUserID = "host_user_id"
        case serviceFee = "service_fee"
        case createdAt = "created_at"
        case addons
        case hostID = "host_id"
        case guestID = "guest_id"
        case bookingHours = "booking_hours"
    }

    // Custom decoding to handle String/Int conversion and optional values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        tax = try? container.decode(String.self, forKey: .tax)
        bookingStart = try? container.decode(String.self, forKey: .bookingStart)
        bookingAmount = try? Self.decodeStringOrInt(from: container, key: .bookingAmount)
        totalAmount = try? Self.decodeStringOrInt(from: container, key: .totalAmount)
        propertyID = try? container.decode(String.self, forKey: .propertyID)
        bookingEnd = try? container.decode(String.self, forKey: .bookingEnd)
        cleaningFee = try? container.decode(String.self, forKey: .cleaningFee)
        guestUserID = try? container.decode(String.self, forKey: .guestUserID)
        id = try? container.decode(Int.self, forKey: .id)
        bookingDate = try? container.decode(String.self, forKey: .bookingDate)
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
        hostUserID = try? container.decode(Int.self, forKey: .hostUserID)
        serviceFee = try? container.decode(String.self, forKey: .serviceFee)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        addons = try? container.decode(String.self, forKey: .addons)
        hostID = try? container.decode(Int.self, forKey: .hostID)
        guestID = try? container.decode(Int.self, forKey: .guestID)
        bookingHours = try? container.decode(Int.self, forKey: .bookingHours)
    }

    private static func decodeStringOrInt(from container: KeyedDecodingContainer<CodingKeys>, key: CodingKeys) throws -> String {
        if let stringValue = try? container.decode(String.self, forKey: key) {
            return stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: key) {
            return String(intValue)
        }
        return "" // Return empty string if value is missing or cannot be decoded
    }
}


//// MARK: - DataClass
//struct BookingModel: Codable {
//    let booking: Booking?
//    let startEndTime: String?
//
//    enum CodingKeys: String, CodingKey {
//        case booking
//        case startEndTime = "start_end_time"
//    }
//}
//


//// MARK: - savedCardModel
//struct SavedCardModel: Codable {
//    let brand, cardID, cardholderName, customerID: String?
//    let email, expMonth, expYear, id: String?
//    let last4: String?
//    let isPreferred: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case brand
//        case cardID = "card_id"
//        case cardholderName = "cardholder_name"
//        case customerID = "customer_id"
//        case email
//        case expMonth = "exp_month"
//        case expYear = "exp_year"
//        case id, last4
//        case isPreferred = "is_preferred"
//    }
//}


// MARK: - DataClass
struct SavedCardModelData: Codable {
    let stripeCustomerID: String?
    let cards: [Card]?

    enum CodingKeys: String, CodingKey {
        case stripeCustomerID = "stripe_customer_id"
        case cards
    }
}

// MARK: - Card
struct Card: Codable {
    let cardholderName, cardID: String?
    var isPreferred: Bool?
    let expMonth, last4, expYear: String?
    let billingAddress: BillingAddress?
    let brand: String?

    enum CodingKeys: String, CodingKey {
        case cardholderName = "cardholder_name"
        case cardID = "card_id"
        case isPreferred = "is_preferred"
        case expMonth = "exp_month"
        case last4
        case expYear = "exp_year"
        case billingAddress = "billing_address"
        case brand
    }
}

// MARK: - BillingAddress
struct BillingAddress: Codable {
    let line2: String?
    let city, state: String?
    let country: String?
    let postalCode, line1: String?

    enum CodingKeys: String, CodingKey {
        case line2, city, state, country
        case postalCode = "postal_code"
        case line1
    }
}
