//
//  FeebackViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 29/05/25.
//

import Combine
import Foundation
import UIKit

class FeebackViewModel:NSObject {
   
    @Published var shareFeedbackResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
}

extension FeebackViewModel {
    
    func apiForShareFeedback(userType : String,details : String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.details] = details
        para[APIKeys.user_type] = userType
       
        APIServices<EmptyModel>().post(endpoint: .feedback, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.shareFeedbackResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.shareFeedbackResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
}
