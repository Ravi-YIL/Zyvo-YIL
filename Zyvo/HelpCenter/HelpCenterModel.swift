//
//  HelpCenterModel.swift
//  Zyvo
//
//  Created by ravi on 6/02/25.
//


// MARK: - DataClass
struct HelpCenterModel: Codable {
    let userID: Int?
    let userFname, userLname: String?
    let guides: [Guide]?
    let articles: [Article]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userFname = "user_fname"
        case userLname = "user_lname"
        case guides, articles
    }
}

// MARK: - Article
struct Article: Codable {
    let id: Int?
    let title, description: String?
}

// MARK: - Guide
struct Guide: Codable {
    let id: Int?
    let title, coverImage: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverImage = "cover_image"
    }
}
