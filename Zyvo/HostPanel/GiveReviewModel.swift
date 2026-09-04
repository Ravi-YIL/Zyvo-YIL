//
//  GiveReviewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/02/25.
//

import Foundation
import Combine
import UIKit

class GiveReviewModel :NSObject{
    
  
    @Published var ReviewResult:Result<BaseResponse<GivenReviewDataModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension GiveReviewModel {
    
    func reviewGuest(bookingId: Int,propertyId: Int, communication: Int, onTime: Int, responseRate:Int, reviewMsgs: String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingId] = bookingId
        para[APIKeys.propertyId] = propertyId
        para[APIKeys.response_rate] = responseRate
        para[APIKeys.communication] = communication
        para[APIKeys.on_time] = onTime
        para[APIKeys.review_message] = reviewMsgs
        
        APIServices<GivenReviewDataModel>().post(endpoint: .review_guest, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Review Given Successfully.....")
                case .failure(let error) :
                    self.ReviewResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.ReviewResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

   
}
