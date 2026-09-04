//
//  VerificationModel.swift
//  Zyvo
//
//  Created by ravi on 21/01/25.
//

import Foundation


// MARK: - 
struct VerificationModel: Codable {
    let userID: Int
    let token: String
    let imgProfileUrl: String?
    let isProfileComplete: Bool


    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
        case imgProfileUrl = "user_image"
        case isProfileComplete = "is_profile_complete"
    }
}






