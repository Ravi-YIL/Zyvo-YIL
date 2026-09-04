//
//  PrivacyPolicyViewModel.swift
//  Zyvo
//
//  Created by ravi on 28/01/25.
//

import Combine
import Foundation
import UIKit

class PrivacyPolicyViewModel :NSObject{
    
  
    //@Published var getTermConditionResult:Result<BaseResponse<[TermConditionModel]>,Error>? = nil
    @Published var getPrivacyPolicyResult:Result<BaseResponse<PrivacyPolicyModel>,Error>? = nil
  //  @Published var getAboutUsResult:Result<BaseResponse<[TermConditionModel]>,Error>? = nil
    
    //@Published var getDeleteAccountResult:Result<BaseResponse<DeleteAccountModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension PrivacyPolicyViewModel {
    
    
//    func apiforDeleteAccount(){
//        var para = [String:Any]()
//        para[APIKeys.userID] = UserDetail.shared.getUserId()
//       
//        APIServices<DeleteAccountModel>().post(endpoint: .user_delete_account, parameters: para,loader: true)
//            .receive(on: DispatchQueue.main)
//            .sink { complition in
//                switch complition{
//                case .finished :
//                    print("Successfully fetched.....")
//                case .failure(let error) :
//                    self.getDeleteAccountResult = .failure(error)
//                }
//            } receiveValue: { response in
//                if response.success ?? false {
//                    self.getDeleteAccountResult = .success(response)
//                }else {
//                    topViewController?.showAlert(for: response.message ?? "")
//                }
//            }.store(in: &cancellables)
//        }
    
    func apiforPrivacyPolicy(){
        var para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<PrivacyPolicyModel>().get(endpoint: .Guestprivacypolicy, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPrivacyPolicyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPrivacyPolicyResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
//    func apiforPrivacyPolicy(){
//        var para = [String:Any]()
//        //para[APIKeys.id] = UserDetail.shared.getUserId()
//        APIServices<[TermConditionModel]>().get(endpoint: .userprivacypolicy, parameters: para,loader: true)
//            .receive(on: DispatchQueue.main)
//            .sink { complition in
//                switch complition{
//                case .finished :
//                    print("Successfully fetched.....")
//                case .failure(let error) :
//                    self.getPrivacyPolicyResult = .failure(error)
//                }
//            } receiveValue: { response in
//                if response.success ?? false {
//                    self.getPrivacyPolicyResult = .success(response)
//                }else {
//                    topViewController?.showAlert(for: response.message ?? "")
//                    
//                }
//            }.store(in: &cancellables)
//
//    }
//    func apiforAboutUs(){
//        var para = [String:Any]()
//        //para[APIKeys.id] = UserDetail.shared.getUserId()
//        APIServices<[TermConditionModel]>().get(endpoint: .userabout, parameters: para,loader: true)
//            .receive(on: DispatchQueue.main)
//            .sink { complition in
//                switch complition{
//                case .finished :
//                    print("Successfully fetched.....")
//                case .failure(let error) :
//                    self.getAboutUsResult = .failure(error)
//                }
//            } receiveValue: { response in
//                if response.success ?? false {
//                    self.getAboutUsResult = .success(response)
//                }else {
//                    topViewController?.showAlert(for: response.message ?? "")
//                    
//                }
//            }.store(in: &cancellables)
//
//    }
    
}
