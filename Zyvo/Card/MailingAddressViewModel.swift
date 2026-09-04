//
//  MailingAddressViewModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.
//

import Combine
import Foundation
import UIKit

class MailingAddressViewModel :NSObject{
    //@Published var getTermConditionResult:Result<BaseResponse<[TermConditionModel]>,Error>? = nil
    @Published var getSavedAddress:Result<BaseResponse<MailingAddressModel>,Error>? = nil
    @Published var addCardResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
}
extension MailingAddressViewModel {
    func apiForGetSavedAddress(){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
           APIServices<MailingAddressModel>().post(endpoint: .same_as_mailing_address, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.getSavedAddress = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.getSavedAddress = .success(response)
                   }else {
                       topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
       }
    
    func apiForAddCard(tokenStripe : String){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
            para[APIKeys.tokenStripe] = tokenStripe
        
           APIServices<EmptyModel>().post(endpoint: .AddCard, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.addCardResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.addCardResult = .success(response)
                   }else {
                       topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
       }
}

