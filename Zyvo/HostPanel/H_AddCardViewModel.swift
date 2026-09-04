//
//  H_AddCardViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 11/03/25.
//

import Foundation
import Combine
import UIKit
import Alamofire

class H_AddCardViewModel :NSObject{
    
  
    @Published var addCardResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension H_AddCardViewModel {
    
    func H_AddCardApi(
        firstName: String,
        lastName: String,
        cardNum: String?,
        token: String?,
        email: String,
        phoneNumber: String,
        dob:[String],
        ssnLast4: String,
        address: String,
        country: String,
        state: String,
        city: String,
        postalCode: String,
        idType: String,
        idNumber: String,
        verificationDocumentFront:Data,
        verificationDocumentBack:Data){
            
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.token] = token
        para[APIKeys.firstname] = firstName
        para[APIKeys.lastname] = lastName
        para[APIKeys.email] = email
        para[APIKeys.phonenumber] = formatPhoneNumberToNormal(phoneNumber)
        para[APIKeys.id_number] = idNumber
        para[APIKeys.address] = address
        para[APIKeys.country] = country
        para[APIKeys.state] = state
        para[APIKeys.city] = city
        para[APIKeys.postal_code] = postalCode
        para[APIKeys.id_type] = idType
        para[APIKeys.id_number] = idNumber
        para[APIKeys.ssn_last_4] = ssnLast4
        para[APIKeys.dob] = dob
        let frontImgDoc = verificationDocumentFront
        let backImgDoc = verificationDocumentBack

        var files: [(data: Data, fileName: String, mimeType: String, key: String)] = [
            (frontImgDoc, "FronDoc", "image/jpeg/application/pdf", "verification_document_front"),
            (backImgDoc, "BackDoc", "image/jpeg/application/pdf", "verification_document_back")
        ]
        print(files)
        APIServices<EmptyModel>().postMultipart(endpoint: .add_payout_card, parameters: para, files: files)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Upload Successful!")
                case .failure(let error):
                    print("Upload Failed:", error)
                }
            }, receiveValue: { response in
                print("Server Response:", response)
                self.addCardResult = .success(response)
            })
            .store(in: &cancellables)
    }
   
}

