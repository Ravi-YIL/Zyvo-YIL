//
//  MailingAddressModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.
//

// MARK: - DataClass
struct MailingAddressModel: Codable {
    let userID: Int?
    let streetAddress, city, state, zipCode: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case streetAddress = "street_address"
        case city, state
        case zipCode = "zip_code"
    }
}

