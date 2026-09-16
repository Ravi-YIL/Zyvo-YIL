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
    private var chatListRequest: AnyCancellable?
}

// MARK: - API Calls
extension ChatDataViewModel {

    func apiForJoinChannel(senderId: String,
                           receiverId: String,
                           groupChannel: String,
                           userType: String,
                           loader: Bool = false) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.apiForJoinChannel(
                    senderId: senderId,
                    receiverId: receiverId,
                    groupChannel: groupChannel,
                    userType: userType,
                    loader: loader
                )
            }
            return
        }
        // The backend channel contract is role-based, not based on who sent the
        // latest message: guest is always sender and host is always receiver.
        // Host screens naturally provide the current host as sender, so reverse
        // those two values before registering/restoring the channel.
        let isHostRequest = userType.trimmingCharacters(in: .whitespacesAndNewlines)
            .caseInsensitiveCompare("host") == .orderedSame
        let guestId = isHostRequest ? receiverId : senderId
        let hostId = isHostRequest ? senderId : receiverId

        var parameters = [String: Any]()
        parameters[APIKeys.senderId] = guestId
        parameters[APIKeys.receiverId] = hostId
        parameters[APIKeys.groupChannel] = groupChannel
        parameters[APIKeys.user_Type] = "guest"
        if let propertyId = ChatChannelName.propertyId(from: groupChannel) {
            parameters[APIKeys.propertyid] = propertyId
        }

        APIServices<JoinChanelModel>().post(endpoint: .joinchannel,
                                            parameters: parameters,
                                            loader: loader)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard self != nil else { return }
                if case .failure(let error) = completion {
                    print("Failed to register chat channel: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard self != nil else { return }
                if response.success != true {
                    let message = response.message ?? "Unknown error"
                    print("Failed to register chat channel: \(message)")
                }
            }
            .store(in: &cancellables)
    }
    
    func apiForGetChatData(userType: String) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.apiForGetChatData(userType: userType)
            }
            return
        }
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.user_type] = userType
        
        chatListRequest?.cancel()
        chatListRequest = APIServices<[ChatDataModel]>().post1(endpoint: .get_user_channels, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complition in
                guard let self = self else { return }
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getChatDataResult = .failure(error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.getChatDataResult = .success(self.deduplicatedChatResponse(response, userType: userType))
            }
    }
    
    func apiForGetChatData2(userType: String, loader: Bool = true) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.apiForGetChatData2(userType: userType, loader: loader)
            }
            return
        }
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.user_type] = userType
        
        chatListRequest?.cancel()
        chatListRequest = APIServices<[ChatDataModel]>().post(endpoint: .get_user_channels, parameters: para, loader: loader)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complition in
                guard let self = self else { return }
                switch complition {
                case .finished:
                    print("Successfully fetched.....")
                case .failure(let error):
                    self.getChatDataResult = .failure(error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.getChatDataResult = .success(self.deduplicatedChatResponse(response, userType: userType))
            }
    }

    func cancelChatListRequest() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.cancelChatListRequest()
            }
            return
        }
        chatListRequest?.cancel()
        chatListRequest = nil
    }

    private func deduplicatedChatResponse(
        _ response: BaseResponse<[ChatDataModel]>,
        userType: String
    ) -> BaseResponse<[ChatDataModel]> {
        var seenChannels = Set<String>()
        let currentUserId = UserDetail.shared.getUserId()
        let roleChats = (response.data ?? []).filter { chat in
            guard let channelName = chat.groupName,
                  channelName.hasPrefix("Zyvoo_guest_") else {
                return true // Keep legacy channels during the migration period.
            }
            if userType.lowercased() == "host" {
                return ChatChannelName.isHostChannel(channelName, userId: currentUserId)
            }
            return ChatChannelName.isGuestChannel(channelName, userId: currentUserId)
        }
        let uniqueChats = roleChats.filter { chat in
            let channelName = (chat.groupName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let key = channelName.isEmpty
                ? "\(chat.senderID ?? "")_\(chat.receiverID ?? "")"
                : channelName
            return seenChannels.insert(key).inserted
        }
        return BaseResponse(
            success: response.success,
            code: response.code,
            message: response.message,
            error: response.error,
            data: uniqueChats,
            pagination: response.pagination,
            hasPaymentMethod: response.hasPaymentMethod
        )
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
        // Legacy backend block/unblock API intentionally disabled.
        // Firestore `blocked_by` is now the only source of truth. New code must
        // call FirebaseChatManager.setMessagingBlocked directly so its result
        // and realtime observer drive the UI without backend status conflicts.
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
        let currentUserId = UserDetail.shared.getUserId()
        let isMuting = mute == "1"

        // Apply mute before waiting for the backend so an incoming message
        // cannot slip through the notification gate during the API round trip.
        if isMuting {
            FirebaseChatManager.shared.setConversationMuted(
                channelName: group_channel,
                userId: currentUserId,
                isMuted: true
            )
        }

        var para = [String: Any]()
        para[APIKeys.userID] = currentUserId
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
                    // Unmute only after the backend accepts it. Mute has already
                    // been applied above to close the notification race window.
                    if !isMuting {
                        FirebaseChatManager.shared.setConversationMuted(
                            channelName: group_channel,
                            userId: currentUserId,
                            isMuted: false
                        )
                    }
                    print("🔕 [ChatMute] Backend API SUCCESS | channel=\(group_channel) user=\(currentUserId) muted=\(isMuting)")
                    self.getMuteUnmuteResult = .success(response)
                } else {
                    print("🔕 [ChatMute] Backend API REJECTED | channel=\(group_channel) user=\(currentUserId) muted=\(isMuting) message=\(response.message ?? "Unknown error")")
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
        print("🔔 [ChatPush] API HIT | sender=\(senderId) receiver=\(receiver_id)")
        var para = [String: Any]()
        para[APIKeys.senderid] = senderId
        para[APIKeys.receiverid] = receiver_id
       
        APIServices<EmptyModel>().post(endpoint: .send_chat_notification, parameters: para, loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("🔔 [ChatPush] API COMPLETED | sender=\(senderId) receiver=\(receiver_id)")
                case .failure(let error):
                    print("🔔 [ChatPush] API FAILED | sender=\(senderId) receiver=\(receiver_id) error=\(error.localizedDescription)")
                    self.sendChatNotiResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    print("🔔 [ChatPush] API SUCCESS | sender=\(senderId) receiver=\(receiver_id)")
                    self.sendChatNotiResult = .success(response)
                } else {
                    print("🔔 [ChatPush] API REJECTED | sender=\(senderId) receiver=\(receiver_id) message=\(response.message ?? "Unknown error")")
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
