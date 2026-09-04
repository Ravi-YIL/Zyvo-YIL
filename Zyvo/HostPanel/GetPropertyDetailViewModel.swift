//
//  GetPropertyDetail.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/02/25.
//

import Foundation
import Combine
import UIKit

class GetPropertyDetailViewModel :NSObject{
    
  
    @Published var getPropertyResult:Result<BaseResponse<GetPropertyModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension GetPropertyDetailViewModel {
    
    func HostGetPropertyDetail(propertyId: Int){
        var para = [String:Any]()
        para[APIKeys.propertyId] = propertyId
        
        APIServices<GetPropertyModel>().post(endpoint: .get_property_details, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPropertyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPropertyResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

   
}

