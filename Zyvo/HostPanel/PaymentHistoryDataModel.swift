//
//  PaymentHistoryDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/03/25.
//

import Foundation
// MARK: - TopLevelElement
struct PaymentHistoryDataModel: Codable {
    let bookingID: Int?
    let bookingAmount, status, bookingDate, guestName: String?
    let guestProfileImage: String?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case bookingAmount = "booking_amount"
        case status
        case bookingDate = "booking_date"
        case guestName = "guest_name"
        case guestProfileImage = "guest_profile_image"
    }
}
struct PayoutBalenceDataModel: Codable {
    let nextPayout,nextPayoutDate: String?
    
    enum CodingKeys: String, CodingKey {
        case nextPayout = "next_payout"
        case nextPayoutDate = "next_payout_date"
    }
}
