//
//  PauseResumeDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 05/05/25.
//

import Foundation
// MARK: - TopLevel
struct PauseResumeDataModel: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: PauseResumeData?
}

// MARK: - DataClass
struct PauseResumeData: Codable {
    let propertyID: Int?
    let propertyStatus: String?

    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case propertyStatus = "property_status"
    }
}
