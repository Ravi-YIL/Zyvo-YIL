//
//  TermCondtionViewModel.swift
//  Zyvo
//
//  Created by ravi on 28/01/25.
//

import Combine
import Foundation
import UIKit

class TermCondtionViewModel :NSObject{
    
  
    @Published var getTermConditionResult:Result<BaseResponse<TermConditionModel>,Error>? = nil
   
    private var cancellables = Set<AnyCancellable>()
    
}
extension TermCondtionViewModel {
    
    func apiforTermCondition(){
        var para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<TermConditionModel>().get(endpoint: .get_term_condition, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getTermConditionResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getTermConditionResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

}
