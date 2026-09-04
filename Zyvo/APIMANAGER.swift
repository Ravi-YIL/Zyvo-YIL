//
//  APIMANAGER.swift
//  Zyvo
//
//  Created by ravi on 20/03/25.
//

import Combine
import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    private var cancellables = Set<AnyCancellable>()
    func apiforGetChatToken(role:String,complition:@escaping(String)-> Void){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.role] = role
        APIServices<chatTokenModel>().post1(endpoint: .chattoken, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) : 
                    print(error,"error")
                    break
                    
                //    self.chatTokenModelResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                 //   self.chatTokenModelResult = .success(response)
                    complition(response.data?.token ?? "")
                    UserDetail.shared.setChatToken(response.data?.token ?? "")
                    UserDefaults.standard.set(response.data?.token ?? "", forKey:"twilioToken")
                    print(response.data?.token ?? "","twilioToken CHAT")
                    QuickstartConversationsManager.shared.loginWithAccessToken(response.data?.token ?? "") { (res) in
                        print("loginWithAccessToken")
                        }
                }else {
                    complition("")
                  //  self.chatTokenModelResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
       }
  }

