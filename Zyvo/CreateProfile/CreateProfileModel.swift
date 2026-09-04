//
//  CreateProfileModel.swift
//  Zyvo
//
//  Created by ravi on 24/01/25.
//

// MARK: - DataClass
struct CreateProfileModel: Codable {
    let isProfileComplete: Bool?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case isProfileComplete = "is_profile_complete"
        case userID = "user_id"
    }
}

