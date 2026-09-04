//
//  GivenReviewDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/02/25.
//

import Foundation

struct GivenReviewDataModel: Codable {
    let reviewBy: String?
    let reviewMessage: String?
    let responseRate, communication, onTime: Int?

    enum CodingKeys: String, CodingKey {
        case reviewBy = "review_by"
        case responseRate = "response_rate"
        case communication
        case onTime = "on_time"
        case reviewMessage = "review_message"
    }
}
