//
//  PropertyListViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 29/01/25.
//

import Foundation
import Combine
import UIKit

class PropertyListViewModel :NSObject{
    
  
    @Published var getPropertyListResult:Result<BaseResponse<[PropertyListModel]>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension PropertyListViewModel {
    
    func apiforGetAllPropertyData(lat:Double ,lot:Double){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.latitude] = lat
        para[APIKeys.longitude] = lot
        APIServices<[PropertyListModel]>().post(endpoint: .get_properties_lists, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPropertyListResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPropertyListResult = .success(response)
                }else {
                    //                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
        
    }
}
