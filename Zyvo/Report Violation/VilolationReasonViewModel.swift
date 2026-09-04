//
//  VilolationReasonViewModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.
//

import Combine
import Foundation
import UIKit

class VilolationReasonViewModel :NSObject{
    
  
    //@Published var getTermConditionResult:Result<BaseResponse<[TermConditionModel]>,Error>? = nil
    @Published var getVilolationResult:Result<BaseResponse<[VilolationReasonModel]>,Error>? = nil
    @Published var getSubmitReportResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var getSubmitChatReportResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    //@Published var getDeleteAccountResult:Result<BaseResponse<DeleteAccountModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension VilolationReasonViewModel {
    

    func apiforGetVioloationReason(){
        var para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<[VilolationReasonModel]>().get(endpoint: .list_report_reasons, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getVilolationResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getVilolationResult = .success(response)
                }else {
                    
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
    
    func apiForSubmitViolationReason(propertyID: String,BookingID: String,reportReasonsID: String,additionaldetails:String){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
           para[APIKeys.propertyid] = propertyID
           para[APIKeys.bookingid] = BookingID
           para[APIKeys.reportreasonsid] = reportReasonsID
           para[APIKeys.additionaldetails] = additionaldetails
        para[APIKeys.additionaldetails] = additionaldetails
        
        
           
           APIServices<EmptyModel>().post(endpoint: .report_violation, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.getSubmitReportResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.getSubmitReportResult = .success(response)
                   }else {
                       topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
           
       }
    
    
    func apiForSubmitChatReport(reporter_id: String,reported_user_id: String,reason: String,message:String,reportReasonID:Int, group_channel:String){
           var para = [String:Any]()
        
           para[APIKeys.reporter_id] = reporter_id
           para[APIKeys.reported_user_id] = reported_user_id
           para[APIKeys.reason] = reason
           para[APIKeys.message] = message
        para[APIKeys.report_reasons_id] = reportReasonID
        para[APIKeys.group_channel] = group_channel
        
         
           APIServices<EmptyModel>().post(endpoint: .report_chat, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.getSubmitChatReportResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.getSubmitChatReportResult = .success(response)
                   }else {
                       self.getSubmitChatReportResult = .success(response)
                       
                       //topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
           
       }
    
    
    
}
