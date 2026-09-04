//
//  AddBankDetailDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 06/03/25.
//

import Foundation

// MARK: - TopLevel
struct AddPayoutBankDetailDataModel: Codable {
    let connectedAccountID, externalAccount: String?

    enum CodingKeys: String, CodingKey {
        case connectedAccountID = "connected_account_id"
        case externalAccount = "external_account"
    }
}
