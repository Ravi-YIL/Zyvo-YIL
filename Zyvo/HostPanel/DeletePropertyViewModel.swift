//
//  DeletePropertyViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 31/01/25.
//

import Combine
import Foundation

class DeletePropertyViewModel {
    
    //    @Published var phone: String = ""
    //    @Published var countryCode: String = ""
    //    @Published var errorMessage: String?
    //    @Published var isloginValid: Bool = false
    //    @Published var createPlaceResult:Result<BaseResponse<PlaceMngmt_Model>,Error>? = nil
    
    @Published var deletePropertyResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
}
    extension DeletePropertyViewModel {
        func apiforDeleteProperty(id:Int){
            var para = [String:Any]()
            para[APIKeys.propertyId] = id
            APIServices<EmptyModel>().post(endpoint: .delete_property, parameters: para,loader: true)
                .receive(on: DispatchQueue.main)
                .sink { complition in
            
                    switch complition{
                    case .finished :
                        print("Successfully fetched.....")
                    case .failure(let error) :
                        self.deletePropertyResult = .failure(error)
                    }
                } receiveValue: { response in
                    if response.success ?? false {
                        self.deletePropertyResult = .success(response)
                    }else {
                        topViewController?.showAlert(for: response.message ?? "")
                        
                    }
                }.store(in: &cancellables)
    }

}
