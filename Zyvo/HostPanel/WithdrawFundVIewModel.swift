//
//  WithdrawFundVIewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 21/03/25.
//

import Foundation
import Combine
import UIKit

class WithdrawFundVIewModel :NSObject{
    
  
    @Published var GetWitdrawAmountResult:Result<BaseResponse<WithdrawFundAmountDataModel>,Error>? = nil
  
    @Published var RequestWitdrawFundResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
}
extension WithdrawFundVIewModel {
    
    func getWithdrawAmount(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<WithdrawFundAmountDataModel>().post(endpoint: .withdraw_funds, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Reported Successfully.....")
                case .failure(let error) :
                    self.GetWitdrawAmountResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.GetWitdrawAmountResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

    func requestWithdrawFund(Amount:String, withdrawType:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.amount] = Amount
        para[APIKeys.withdrawal_type] = withdrawType
        
        APIServices<EmptyModel>().post(endpoint: .request_withdrawal, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Success.....")
                case .failure(let error) :
                    self.RequestWitdrawFundResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.RequestWitdrawFundResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
   
}
