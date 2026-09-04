//
//  AllArticleModel.swift
//  Zyvo
//
//  Created by ravi on 6/02/25.
//

// MARK: - Datum
struct AllArticleModel: Codable {
    let id: Int?
    let title, description, coverImage: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case coverImage = "cover_image"
    }
}

