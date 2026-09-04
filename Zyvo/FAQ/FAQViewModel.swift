//
//  FAQViewModel.swift
//  Zyvo
//
//  Created by ravi on 06/05/2025.
//

import Combine
import Foundation
import UIKit

class FAQViewModel :NSObject{
    
  
    @Published var getFAQResult:Result<BaseResponse<[FAQModel]>,Error>? = nil
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension FAQViewModel {
    
    func apiforGetFAQ(){
        let para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<[FAQModel]>().get(endpoint: .getfaq, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getFAQResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getFAQResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
        
    }
}
