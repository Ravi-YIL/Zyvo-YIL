//
//  BookingAPIModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 19/01/26.
//
import Foundation

struct BookingAPIModel: Codable {
    let booking_start_end: String
    let booking_status: String
    let guest_name: String
    let booking_id: Int
    let booking_date: String
}

struct BookingNew {
    let date: Date
    let startHour: Int
    let endHour: Int
    let guestName: String
    let status: String
}
