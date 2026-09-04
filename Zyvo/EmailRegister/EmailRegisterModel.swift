//
//  EmailRegisterModel.swift
//  Zyvo
//
//  Created by ravi on 22/01/25.
//

import Foundation

// MARK: - DataClass
struct EmailRegisterModel: Codable {
    let otp, tempID: Int
    let isprofilecomplete: Bool

    enum CodingKeys: String, CodingKey {
        case otp
        case tempID = "temp_id"
        case isprofilecomplete = "is_profile_complete"
        
        
    }
}
