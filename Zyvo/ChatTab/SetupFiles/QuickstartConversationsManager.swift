//
//  QuickstartConversationsManager.swift
//  ConversationsQuickstart
//
//  Created by Jeffrey Linwood on 9/12/20.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import UIKit
import TwilioConversationsClient

protocol QuickstartConversationsManagerDelegate: AnyObject {
    func getClient(client: TwilioConversationsClient?)
    func reloadMessages()
    func receivedNewMessage(message: TCHMessage)
    func displayStatusMessage(_ statusMessage: String)
    func displayErrorMessage(_ errorMessage: String)
    func startTyping(participant: TCHParticipant)
    func endTyping(participant: TCHParticipant)
}

class QuickstartConversationsManager: NSObject, TwilioConversationsClientDelegate {
    
    static let shared = QuickstartConversationsManager()
    
    // MARK: - Properties
    
    weak var delegate: QuickstartConversationsManagerDelegate?
    private var uniqueConversationName = ""
    private var friendIdentity = ""
    private(set) var messages: [TCHMessage] = []
    var client: TwilioConversationsClient?
    var conversation: TCHConversation?
    var myConversationon : ((TwilioConversationsClient?) -> Void)?
    var myMsg : ((TCHMessage?) -> Void)?
    private var retryCount = 4
    
    var onConversationReady: (() -> Void)?
    
    // MARK: - Twilio Client Setup
    func loginWithAccessToken(_ token: String, completion: @escaping (TwilioConversationsClient?) -> Void) {
        TwilioConversationsClient.conversationsClient(withToken: token, properties: nil, delegate: self) { result, client in
            print(result,"result")
            if result.isSuccessful {
                print("YES CHAT LOGIN")
                self.client = client
                completion(client)
            } else if self.retryCount > 0 {
                self.retryCount -= 1
                self.loginWithAccessToken(token, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    
    func cleanupTwilio() {

         client?.delegate = nil

         client?.shutdown()

         client = nil
     }
    
    func lastReadTime(conversation: TCHConversation, identity: String)-> String {
        guard let participant = conversation.participant(withIdentity: identity) else {
            print("Participant with identity \(identity) not found in conversation.")
            return ""
        }
     var lastSeenDate1 = ""
        if let lastSeenTimestamp = participant.lastReadTimestamp {
            print(lastSeenTimestamp,"lastSeenTimestamp")
            let lastSeenDate = getFormattedLastSeen(timestamp: lastSeenTimestamp) // Convert to readable date
            //delegate?.onlineOffline(lastSeenDate)
            print("Last seen at: \(lastSeenDate)")
            lastSeenDate1 = lastSeenDate
        }
        return   lastSeenDate1
    }

    // Helper function to format timestamp into a readable date string
    private func getFormattedLastSeen(timestamp: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        guard let date = dateFormatter.date(from: timestamp) else {
            return "Invalid timestamp"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return outputFormatter.string(from: date)
    }

    
    func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        guard status == .completed else { return }
        delegate?.getClient(client: client)
    }
    
    // MARK: - Conversation Management
    func loadChat(uniqueConversationName: String, friendIdentity: String) {
        self.uniqueConversationName = uniqueConversationName
        self.friendIdentity = friendIdentity
        
        checkOrCreateConversation { success, conversation in
            
            if success, let conversation = conversation {
                self.joinConversation(conversation)
                self.addParticipantToConversation()
                
            }
        }
       
    }
    
    private func checkOrCreateConversation(completion: @escaping (Bool, TCHConversation?) -> Void) {
        client?.conversation(withSidOrUniqueName: uniqueConversationName) { result, conversation in
            if let conversation = conversation {
                completion(true, conversation)
            } else {
                self.createConversation(completion: completion)
            }
        }
    }
    
    private func createConversation(completion: @escaping (Bool, TCHConversation?) -> Void) {
        client?.createConversation(options: [TCHConversationOptionUniqueName: uniqueConversationName]) { result, conversation in
            if result.isSuccessful {
                print("Conversation created.")
            } else {
                print("Error creating conversation: \(result.error?.localizedDescription ?? "Unknown error")")
            }
            completion(result.isSuccessful, conversation)
        }
    }
    
    private func joinConversation(_ conversation: TCHConversation) {
        self.conversation = conversation
        if conversation.status == .joined {
            loadPreviousMessages(conversation)
        } else {
            conversation.join { result in
                if result.isSuccessful {
                    self.loadPreviousMessages(conversation)
                    
                }
            }
        }
    }
    
    private func addParticipantToConversation() {
        print(friendIdentity,"friendIdentity")
        guard let conversation = conversation, !friendIdentity.isEmpty else { return }
        conversation.addParticipant(byIdentity: friendIdentity, attributes: nil) { result in
            if result.isSuccessful {
                print("Participant added.")
                
            } else {
                print(result.error?.localizedDescription ?? "Unknown error")
                print("Failed to add participant.")
                conversation.getParticipantsCount(completion: { result, count in
                    if result.isSuccessful {
                        print("added memeber count: \(count)")
                    }else{
                        print("Error member count for conversation: \(result.error?.localizedDescription ?? "Unknown error")")
                    }
                })
                
            }
        }
    }
    
    private func loadPreviousMessages(_ conversation: TCHConversation) {
        conversation.getLastMessages(withCount: 50) { result, messages in
            if let messages = messages {
                self.messages = messages
                DispatchQueue.main.async {
                    self.delegate?.reloadMessages()
                    self.onConversationReady?()
                }
            }
        }
    }
    
    // MARK: - Message Handling
    func sendMessage(_ messageText: String, completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        if let conversation = conversation {
            conversation.prepareMessage().setBody(messageText).buildAndSend(completion: completion)
        }

    }
    
    func sendMediaMessage(data: Data, contentType: String, fileName: String, completion: @escaping (TCHResult?, TCHMessage?) -> Void) {
        guard let conversation = conversation else { return }
        
        conversation.prepareMessage()
            .addMedia(data: data, contentType: contentType, filename: fileName, listener: .init(
                onStarted: {
                    print("Media upload started")
                },
                onProgress: { bytes in
                    print("Media upload progress: \(bytes)")
                },
                onCompleted: { sid in
                    print("Media upload completed with SID: \(sid ?? "N/A")")
                },
                onFailed: { error in
                    print("Media upload failed with error: \(error)")
                }
            ))
            .buildAndSend { result, message in
                if result.isSuccessful, let message = message {
                    print("Image message sent successfully")
                    DispatchQueue.main.async {
                        self.delegate?.receivedNewMessage(message: message)
                    }
                } else {
                    print("Failed to send image message: \(String(describing: result.error))")
                }
                completion(result, message)
            }
    }

    
    // MARK: - Token Management
    func conversationsClientTokenWillExpire(_ client: TwilioConversationsClient) {
        print("Access token will expire.")
        refreshAccessToken()
    }
    
    func conversationsClientTokenExpired(_ client: TwilioConversationsClient) {
        print("Access token expired.")
        refreshAccessToken()
    }
    
    private func refreshAccessToken() {
        
        APIManager.shared.apiforGetChatToken(role:"guest") { token in
            UserDefaults.standard.set(token, forKey:"twilioToken")
            self.client?.updateToken(token) { result in
                print(result.isSuccessful ? "Access token refreshed" : "Failed to refresh access token")
            }
        }
    }
    
   
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation,
                    messageAdded message: TCHMessage) {
        messages.append(message)
        print(message.body,"manager class")
        self.myMsg?(message)
        DispatchQueue.main.async {
          if let delegate = self.delegate {
            self.delegate?.receivedNewMessage(message: message)
                self.myConversationon?(client)
          }
        }
    }
    
    // MARK: - Typing Events
    
    
    func conversationsClient(_ client: TwilioConversationsClient, typingStartedOn conversation: TCHConversation, participant: TCHParticipant) {
        if conversation == self.conversation {
            delegate?.startTyping(participant: participant)
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, typingEndedOn conversation: TCHConversation, participant: TCHParticipant) {
        if conversation == self.conversation {
            delegate?.endTyping(participant: participant)
        }
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participantJoined participant: TCHParticipant) {
        print("\(participant.identity ?? "Unknown") joined the conversation.")
        delegate?.displayStatusMessage("\(participant.identity ?? "Unknown") joined the chat.")
    }

    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participantLeft participant: TCHParticipant) {
        print("\(participant.identity ?? "Unknown") left the conversation.")
        delegate?.displayStatusMessage("\(participant.identity ?? "Unknown") left the chat.")
    }
    
    

    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation, participant: TCHParticipant, updated update: TCHParticipantUpdate) {
        print("\(participant.identity ?? "Unknown") updated: \(update)")
    }
    
    // MARK: - Cleanup
    func shutdown() {
        client?.delegate = nil
        client?.shutdown()
        client = nil
    }
    
    func checkTwilioUserStatus(userId: String, completion: @escaping (String) -> Void) {
        guard let client = client else {
            completion("Twilio client not available")
            return
        }
        
        client.subscribedUser(withIdentity: userId) { result, user in
            if result.isSuccessful, let user = user {
                if user.isOnline() {
                    completion("\(user.identity) is Online")
                } else {
                    completion("\(user.identity) is offline")
                    print( user.attributes())
                    if let attributes = user.attributes() as? [String: Any],
                       let lastUpdated = attributes["lastUpdated"] as? String {
                        print("User last updated at: \(lastUpdated)")
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                   // let lastSeenStr = formatter.string(from: lastSeen)
                    
                   // completion("\(user.identity) was last seen at \(lastSeenStr)")
                }
            } else {
                let errorMessage = result.error?.localizedDescription ?? "Unknown error"
                completion("Error fetching user: \(errorMessage)")
            }
        }
    }

    

}



struct ChatMessage {
    var text: String?
    var imageUrl: String?
}
