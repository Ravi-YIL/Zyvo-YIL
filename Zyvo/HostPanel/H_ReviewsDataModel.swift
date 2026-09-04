//
//  H_ReviewsDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/02/25.
//

import Foundation
import UIKit
// MARK: - Datum
struct H_ReviewsDataModel: Codable {
    let reviewerName, profileImage, reviewRating, reviewMessage: String?
    let reviewDate: String?

    enum CodingKeys: String, CodingKey {
        case reviewerName = "reviewer_name"
        case profileImage = "profile_image"
        case reviewRating = "review_rating"
        case reviewMessage = "review_message"
        case reviewDate = "review_date"
    }
}

struct CustomBokingDetail{
    var txt: String?
    var img: UIImage?
}
//// MARK: - Pagination
//struct Pagination: Codable {
//    let total, count, perPage, currentPage: Int?
//    let totalPages: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case total, count
//        case perPage = "per_page"
//        case currentPage = "current_page"
//        case totalPages = "total_pages"
//    }
//}
