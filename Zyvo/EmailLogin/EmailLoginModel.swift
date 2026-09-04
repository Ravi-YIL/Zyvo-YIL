//
//  EmailLoginModel.swift
//  Zyvo
//
//  Created by ravi on 22/01/25.
//

// MARK: - DataClass
struct EmailLoginModel: Codable {
    let userID: Int?
    let token: String?
    let isprofilecomplete: Bool?
    let imgProfileurl: String?
    let fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
        case isprofilecomplete = "is_profile_complete"
        case imgProfileurl = "user_image"
        case fullName = "full_name"
    }
}
