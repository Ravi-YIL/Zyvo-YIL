//
//  UpdateNameModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//

import Foundation

// MARK: - DataClass
struct UpdateNameModel: Codable {
    let userID: Int?
    let fname, lname: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case fname, lname
    }
}
