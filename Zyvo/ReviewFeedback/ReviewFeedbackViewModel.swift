//
//  ReviewFeedbackViewModel.swift
//  Zyvo
//
//  Created by ravi on 31/01/25.
//

import Combine
import Foundation
import UIKit

class ReviewFeedbackViewModel:NSObject {
    @Published var errorMessage: String?
   
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    
    @Published var reviewMSG: String = ""
   
   
    @Published var isProfileValid: Bool = false
    
    @Published var reviewHostResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension ReviewFeedbackViewModel {
    
    func apiForReviewHost(bookingid:String,propertyid:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingid] = bookingid
        para[APIKeys.propertyid] = propertyid
        para[APIKeys.responserate] = self.responseRate
        para[APIKeys.communication] = Communication
        para[APIKeys.ontime] = onTime
        para[APIKeys.reviewmessage] = reviewMSG
        APIServices<EmptyModel>().post(endpoint: .reviewhost, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.reviewHostResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.reviewHostResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
}
