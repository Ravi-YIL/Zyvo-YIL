//
//  WithdrawFundAmountDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 21/03/25.
//

import Foundation
// MARK: - TopLevel
struct WithdrawFundAmountDataModel: Codable {
    let availableBalance, instantAvailableBalance: String?

    enum CodingKeys: String, CodingKey {
        case availableBalance = "available_balance"
        case instantAvailableBalance = "instant_available_balance"
    }
}
