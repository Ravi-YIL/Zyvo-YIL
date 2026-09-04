//
//  BaseResponse.swift
//  LawCo
//
//  Created by YATIN  KALRA on 12/06/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool?
    let code: Int?
    let message: String?
    let error: String?
    let data: T?
    let pagination: Pagination?
    let hasPaymentMethod: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success, code, message, error, data, pagination
        case hasPaymentMethod = "has_payment_method"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        data = try container.decodeIfPresent(T.self, forKey: .data)
        pagination = try container.decodeIfPresent(Pagination.self, forKey: .pagination)
        
        if let boolVal = try? container.decodeIfPresent(Bool.self, forKey: .hasPaymentMethod) {
            hasPaymentMethod = boolVal
        } else if let intVal = try? container.decodeIfPresent(Int.self, forKey: .hasPaymentMethod) {
            hasPaymentMethod = (intVal == 1)
        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .hasPaymentMethod) {
            hasPaymentMethod = (strVal == "1" || strVal.lowercased() == "true")
        } else {
            hasPaymentMethod = nil
        }
    }
}



