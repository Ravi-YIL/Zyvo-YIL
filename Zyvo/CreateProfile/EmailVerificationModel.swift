//
//  EmailVerificationModel.swift
//  Zyvo
//
//  Created by ravi on 24/01/25.
//

// MARK: - DataClass
struct EmailVerificationModel: Codable {
    let userID: Int?
    let email: String?
    let otp: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, otp
    }
}



// MARK: - DataClass
struct EmailUpdateVerificationModel: Codable {
    let userID, otp: Int?
    let otpSendTo: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case otp
        case otpSendTo = "otp_send_to"
    }
}
