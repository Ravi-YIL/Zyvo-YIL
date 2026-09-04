//
//  ReportModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/02/25.
//

import Foundation
import Combine
import UIKit

class ReportViewModel :NSObject{
    
  
    @Published var ReportResult:Result<BaseResponse<EmptyModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension ReportViewModel {
    
    func reviewGuest(booking_id: Int, property_id: Int, reportReasonsId:Int, additionalDetails: String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingId] = booking_id
        para[APIKeys.propertyId] = property_id
        para[APIKeys.report_reasons_id] = reportReasonsId
        para[APIKeys.additional_details] = additionalDetails
        
        APIServices<EmptyModel>().post(endpoint: .host_report_violation, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Reported Successfully.....")
                case .failure(let error) :
                    self.ReportResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.ReportResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

    
   
}
