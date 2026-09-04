//
//  AllGuidesModel.swift
//  Zyvo
//
//  Created by ravi on 7/02/25.
//


// MARK: - Datum
struct AllGuidesModel: Codable {
    let id: Int?
    let title, coverImage: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverImage = "cover_image"
    }
}
