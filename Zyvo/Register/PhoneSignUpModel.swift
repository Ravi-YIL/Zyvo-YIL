//
//  PhoneSignUpModel.swift
//  Zyvo
//
//  Created by ravi on 21/01/25.
//

import Foundation



// MARK: - DataClass
struct PhoneSignUpModel: Codable {
    let otp, tempID: Int
    let isprofilecomplete : Bool?

    enum CodingKeys: String, CodingKey {
        case otp
        case tempID = "temp_id"
        case isprofilecomplete = "is_profile_complete"
    }
}



// MARK: - UserDetails
struct UserDetails1: Codable {
    let email, name, loginType: String

    enum CodingKeys: String, CodingKey {
        case email, name
        case loginType = "login_type"
    }
}

//// MARK: - DataClass
//struct SocialSignUpModel: Codable {
//    let userID: Int?
//    let isloginfirst: String?
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case isloginfirst
//    }
//}


// MARK: - DataClass
struct SocialSignUpModel: Codable {
    let userID: Int?
    let isloginfirst, token: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isloginfirst, token
    }
}

