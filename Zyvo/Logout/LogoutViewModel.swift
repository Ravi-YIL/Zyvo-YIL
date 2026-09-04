//
//  LogoutViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 26/05/25.
//

import Combine
import Foundation
import UIKit

class LogoutViewModel:NSObject {
    
    @Published var logOutResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func apiForLogOut(){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
           APIServices<EmptyModel>().post(endpoint: .logout, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.logOutResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.logOutResult = .success(response)
                   }else {
                     //  topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
       }
    
}
