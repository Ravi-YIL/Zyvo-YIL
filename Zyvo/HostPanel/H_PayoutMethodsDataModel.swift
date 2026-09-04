//
//  H_PayoutMethodsDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 10/03/25.
//

import Foundation
// MARK: - TopLevel
struct H_PayoutMethodsDataModel: Codable {
    let bankAccounts: [H_BankAccount]?
    let cards: [H_Card]?

    enum CodingKeys: String, CodingKey {
        case bankAccounts = "bank_accounts"
        case cards
    }
}

// MARK: - BankAccount
struct H_BankAccount: Codable {
    let id, bankName, lastFourDigits, currency: String?
    let defaultForCurrency: Bool?
    let accountHolderName, accountHolderType, status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case bankName = "bank_name"
        case lastFourDigits = "last_four_digits"
        case currency
        case defaultForCurrency = "default_for_currency"
        case accountHolderName = "account_holder_name"
        case accountHolderType = "account_holder_type"
        case status
    }
}

// MARK: - Card
struct H_Card: Codable {
    let expYear, expMonth: Int?
    let defaultForCurrency: Bool?
    let lastFourDigits, brand, currency, id: String?

    enum CodingKeys: String, CodingKey {
        case expYear = "exp_year"
        case expMonth = "exp_month"
        case defaultForCurrency = "default_for_currency"
        case lastFourDigits = "last_four_digits"
        case brand, currency, id
    }
}


struct H_PayoutMethodDetail{
    var methodType : String?
    var id : String?
    var last4Digitnumber: String?
    var holderName: String?
    var expMonth: Int?
    var expYear: Int?
    var currency: String?
    var cardBrand: String?
    var bankName: String?
    var isPrimary: Bool?
}
