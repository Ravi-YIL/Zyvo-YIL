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
        FirebaseChatManager.shared.connect { _ in
            complition("")
        }
       }
  }
