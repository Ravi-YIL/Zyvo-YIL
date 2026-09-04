//
//  NotificationViewModel.swift
//  Zyvo
//
//  Created by ravi on 27/02/25.
//

import Combine
import Foundation

class NotificationViewModel {
  
    @Published var NotiResult:Result<BaseResponse<[NotificationModel]>,Error>? = nil
    @Published var readNotiResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
  
    init() {
       
    }
    
    
   
  
}

extension NotificationViewModel{
    
    func apiforGetNotificationHost(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<[NotificationModel]>().post(endpoint: .get_notification_host, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.NotiResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.NotiResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    func apiforGetNotification(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<[NotificationModel]>().post(endpoint: .get_notification_guest, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.NotiResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.NotiResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiforReadNotification(notiID : String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = "1"// UserDetail.shared.getUserId()
        para[APIKeys.notificationID] = notiID
        
        APIServices<EmptyModel>().post(endpoint: .mark_notification_read, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.readNotiResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.readNotiResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
        
    }

}

