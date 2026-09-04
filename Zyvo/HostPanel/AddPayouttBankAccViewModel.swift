//
//  AddBankAccViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 06/03/25.
//

import Foundation
import Combine
import UIKit
import Alamofire

class AddPayouttBankAccViewModel :NSObject{
    
  
    @Published var addBankDetailResult:Result<BaseResponse<AddPayoutBankDetailDataModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension AddPayouttBankAccViewModel {
    
    func H_AddbankAcount(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        idType: String,
        ssnLast4: String,
        idNumber: String,
        address: String,
        country: String,
        state: String,
        city: String,
        postalCode: String,
        bankName: String,
        accountHolderName: String,
        accountNumber: String,
        accountNumberConfirmation: String,
        routingNumber: String,
        dob:[String],
        bankProofType: String,
        bankProofDocument:Data,
        verificationDocumentFront:Data,
        verificationDocumentBack:Data
        
    ){
        var para = [String:Any]()
        
       
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
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
        para[APIKeys.bank_name] = bankName
        para[APIKeys.account_holder_name] = accountHolderName
        para[APIKeys.account_number] = accountNumber
        para[APIKeys.account_number_confirmation] = accountNumberConfirmation
        para[APIKeys.routing_number] = routingNumber
        para[APIKeys.id_type] = idType
        para[APIKeys.id_number] = idNumber
        para[APIKeys.ssn_last_4] = ssnLast4
        para[APIKeys.bank_proof_type] = bankProofType
        para[APIKeys.dob] = dob
        let bankProofDoc = bankProofDocument
        let frontImgDoc = verificationDocumentFront
        let backImgDoc = verificationDocumentBack

        var files: [(data: Data, fileName: String, mimeType: String, key: String)] = [
            (frontImgDoc, "FronDoc", "image/jpeg/application/pdf", "verification_document_front"),
            (backImgDoc, "BackDoc", "image/jpeg/application/pdf", "verification_document_back"),
            (bankProofDoc, "document.pdf", "image/jpeg/application/pdf", "bank_proof_document")
        ]
        print(files)
        APIServices<AddPayoutBankDetailDataModel>().postMultipart(endpoint: .add_payout_bank, parameters: para, files: files)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Upload Successful!")
                case .failure(let error):
                    print("Upload Failed:", error)
                }
            }, receiveValue: { response in
                self.addBankDetailResult = .success(response)
                print("Server Response:", response)
            })
            .store(in: &cancellables)
    }
   
}
