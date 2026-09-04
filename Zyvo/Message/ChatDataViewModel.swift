//
//  ChatDataViewModel.swift
//  Zyvo
//
//  Created by ravi on 21/03/25.
//

import Combine
import Foundation
import UIKit

class ChatDataViewModel: NSObject {
    
    // MARK: - Published Properties
    @Published var getChatDataResult: Result<BaseResponse<[ChatDataModel]>, Error>? = nil
    @Published var blockResult: Result<BaseResponse<UserBlockStatusModel>, Error>? = nil
    @Published var chekcBlockResult: Result<BaseResponse<UserBlockStatusModel>, Error>? = nil
    @Published var chekcBlockResult2: Result<BaseResponse<UserBlockStatusModel>, Error>? = nil
    @Published var getFavResult: Result<BaseResponse<ChatFavouriteModel>, Error>? = nil
    @Published var getUnreadBookingCount: Result<BaseResponse<unreadbookingModel>, Error>? = nil
    @Published var getMuteUnmuteResult: Result<BaseResponse<SetMuteUnmute>, Error>? = nil
    @Published var setArchiveResult: Result<BaseResponse<SetArchiveUnarchiveModel>, Error>? = nil
    @Published var sendChatNotiResult: Result<BaseResponse<EmptyModel>, Error>? = nil
    @Published var getDeleteChatResult: Result<BaseResponse<EmptyModel>, Error>? = nil
    
    // MARK: - Properties
    var latitude = ""
    var longitude = ""
    var datss = ""
    var hourss = 2
    var start_time = ""
    var end_time = ""
    var activity = ""
    var locationss = ""
    var bookingDate = ""
    var bookingStart = ""
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - API Calls
extension ChatDataViewModel {
    
    func apiForGetChatData(userType: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.user_type] = userType
        
        APIServices<[ChatDataModel]>().post1(endpoint: .get_user_channels, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getChatDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getChatDataResult = .success(response)
                } else {
                    self.getChatDataResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForGetChatData2(userType: String, loader: Bool = true) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.user_type] = userType
        
        APIServices<[ChatDataModel]>().post(endpoint: .get_user_channels, parameters: para, loader: loader)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getChatDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getChatDataResult = .success(response)
                } else {
                    self.getChatDataResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForCheckBlockUser(IDSS: String, group_channel: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = IDSS
        para[APIKeys.group_channel] = group_channel
        
        APIServices<UserBlockStatusModel>().post1(endpoint: .checkBlockStatus, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.chekcBlockResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.chekcBlockResult = .success(response)
                } else {
                    self.chekcBlockResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForCheckBlockUser2(IDSS: String, group_channel: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = IDSS
        para[APIKeys.group_channel] = group_channel
        
        APIServices<UserBlockStatusModel>().post1(endpoint: .checkBlockStatus, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.chekcBlockResult2 = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.chekcBlockResult2 = .success(response)
                } else {
                    self.chekcBlockResult2 = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForBlockUser(senderId: String, group_channel: String, blockUnblock: Int) {
        var para = [String: Any]()
        para[APIKeys.senderId] = senderId
        para[APIKeys.group_channel] = group_channel
        para[APIKeys.blockUnblock] = blockUnblock
        
        APIServices<UserBlockStatusModel>().post(endpoint: .block_user, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.blockResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.blockResult = .success(response)
                } else {
                    self.blockResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForSetFavourite(senderId: String, group_channel: String, favorite: String) {
        var para = [String: Any]()
        para[APIKeys.senderId] = senderId
        para[APIKeys.group_channel] = group_channel
        para[APIKeys.favorite] = favorite
        
        APIServices<ChatFavouriteModel>().post(endpoint: .mark_favorite_chat, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getFavResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getFavResult = .success(response)
                } else {
                    self.getFavResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForSetMuteUnmute(senderId: String, group_channel: String, mute: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.group_channel] = group_channel
        para[APIKeys.mute] = mute
        
        APIServices<SetMuteUnmute>().post(endpoint: .mute_chat, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getMuteUnmuteResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getMuteUnmuteResult = .success(response)
                } else {
                    self.getMuteUnmuteResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForSetArchiveUnarchive(senderId: String, group_channel: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.group_channel] = group_channel
       
        APIServices<SetArchiveUnarchiveModel>().post(endpoint: .toggle_archive_unarchive, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.setArchiveResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.setArchiveResult = .success(response)
                } else {
                    self.setArchiveResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForSendChatNotification(senderId: String, receiver_id: String) {
        var para = [String: Any]()
        para[APIKeys.senderid] = senderId
        para[APIKeys.receiverid] = receiver_id
       
        APIServices<EmptyModel>().post(endpoint: .send_chat_notification, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.sendChatNotiResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.sendChatNotiResult = .success(response)
                } else {
                    self.sendChatNotiResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForDeleteChat(userType: String, groupChannel: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.usertype] = userType
        para[APIKeys.group_channel] = groupChannel
       
        APIServices<EmptyModel>().post(endpoint: .delete_chat, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getDeleteChatResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getDeleteChatResult = .success(response)
                } else {
                    self.getDeleteChatResult = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    func apiForGetUnreadCount() {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
      
        APIServices<unreadbookingModel>().post1(endpoint: .host_unread_bookings, parameters: para, loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getUnreadBookingCount = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getUnreadBookingCount = .success(response)
                } else {
                    self.getUnreadBookingCount = .success(response)
                }
            }.store(in: &cancellables)
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let unreadBookingCount: Int?

        enum CodingKeys: String, CodingKey {
            case unreadBookingCount = "unread_booking_count"
        }
    }
}

