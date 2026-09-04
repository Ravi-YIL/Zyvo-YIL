//
//  ForgotPasswordModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//


import Foundation

// MARK: - DataClass
struct ForgotPasswordModel: Codable {
    let userID: Int?
    let email: String?
    let otp: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, otp
    }
}

// MARK: - Welcome
struct verifyforgotpasswordModel: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
   let data: [String]?
}
