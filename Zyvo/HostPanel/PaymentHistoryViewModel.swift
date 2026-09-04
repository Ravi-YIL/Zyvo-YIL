//
//  PaymentHistoryViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/03/25.
//

import Foundation
import Combine
import UIKit

class PaymentHistoryViewModel :NSObject{
    
    @Published var getPaymentHistoryResult:Result<BaseResponse<[PaymentHistoryDataModel]>,Error>? = nil
    @Published var getPayoutBalanceResult:Result<BaseResponse<PayoutBalenceDataModel>,Error>? = nil
    @Published var getPayoutMethodsResult:Result<BaseResponse<H_PayoutMethodsDataModel>,Error>? = nil
    @Published var SetPrimaryPayoutMethodsResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var DeletePayoutMethodsResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension PaymentHistoryViewModel {
    
    //Payment History API
    func apiforGetPaymentHistory(startDate: String?,endDate: String?,filterStatus: String?){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.start_date] = startDate
        para[APIKeys.end_date] = endDate
        para[APIKeys.filter_status] = filterStatus
        APIServices<[PaymentHistoryDataModel]>().post(endpoint: .payment_withdrawal_list, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPaymentHistoryResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPaymentHistoryResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }

    //Payout Methods API
    func apiforGetPayoutMethods(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<H_PayoutMethodsDataModel>().post(endpoint: .get_payout_methods, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPayoutMethodsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPayoutMethodsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
   
    //Payout Balence API
    func apiforGetPayoutBalence(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<PayoutBalenceDataModel>().post(endpoint: .payout_balance, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPayoutBalanceResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPayoutBalanceResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    //Set Primary Method Api
    func apiforSetPrimaryMethod(id: String?){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.payout_method_id] = id
        
        APIServices<EmptyModel>().post(endpoint: .set_primary_payout_method, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.SetPrimaryPayoutMethodsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.SetPrimaryPayoutMethodsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    //Delete Method Api
    func apiforDeletePayoutMethod(id: String?){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.payout_method_id] = id
        
        APIServices<EmptyModel>().post(endpoint: .delete_payout_method, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.DeletePayoutMethodsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.DeletePayoutMethodsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
}
