//
//  GuideDetailsModel.swift
//  Zyvo
//
//  Created by ravi on 7/02/25.
//

// MARK: - DataClass
struct GuideDetailsModel: Codable {
    let guideID: Int?
    let title, timeRequired, date, description: String?
    let coverImage, authorName, category: String?

    enum CodingKeys: String, CodingKey {
        case guideID = "guide_id"
        case title
        case timeRequired = "time_required"
        case date, description
        case coverImage = "cover_image"
        case authorName = "author_name"
        case category
    }
}


// MARK: - DataClass
struct ArticleDetailsModel: Codable {
    let articleID: Int?
    let title, timeRequired, date, description: String?
    let coverImage, authorName, category: String?

    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title
        case timeRequired = "time_required"
        case date, description
        case coverImage = "cover_image"
        case authorName = "author_name"
        case category
    }
}
