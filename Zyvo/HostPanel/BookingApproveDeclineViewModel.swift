//
//  BookingApproveDeclineViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 17/02/25.
//

import Foundation
import Combine
import UIKit

class BookingApproveDeclineViewModel :NSObject{
    
  
    @Published var getApproveDeclineResult:Result<BaseResponse<EmptyModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension BookingApproveDeclineViewModel {
    
    func approveDeclineBooking(bookingID: String,extId: Int, status: String, hostMessage: String, declinedReason:String){
        var para = [String:Any]()
        
        para[APIKeys.bookingId] = bookingID
        para[APIKeys.status] = status
        para[APIKeys.hostMessage] = hostMessage
        para[APIKeys.declinedReason] = declinedReason
        if extId == 0{
            para[APIKeys.extension_Id] = ""
        }else{
            para[APIKeys.extension_Id] = extId
        }
        
        APIServices<EmptyModel>().post(endpoint: .approve_decline_booking, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getApproveDeclineResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getApproveDeclineResult = .success(response)
                }else {
                    self.getApproveDeclineResult = .success(response)
//                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

   
}
