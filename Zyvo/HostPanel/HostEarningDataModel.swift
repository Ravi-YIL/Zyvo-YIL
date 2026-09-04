//
//  HostEarningDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 14/02/25.
//

import Foundation
struct HostEarningDataModel: Codable {
    let type, hostID, amount: String?

    enum CodingKeys: String, CodingKey {
        case type
        case hostID = "host_id"
        case amount
    }
}
