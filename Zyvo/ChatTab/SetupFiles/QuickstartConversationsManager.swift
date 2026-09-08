//
//  QuickstartConversationsManager.swift
//  Zyvo
//
//  Firestore-backed chat engine. The filename is retained because it is already
//  referenced by the Xcode project.
//

import Foundation
import FirebaseFirestore
import UIKit
import Alamofire

enum ChatChannelName {
    static func make(guestId: String, hostId: String) -> String {
        let guest = guestId.trimmingCharacters(in: .whitespacesAndNewlines)
        let host = hostId.trimmingCharacters(in: .whitespacesAndNewlines)
        return "Zyvoo_guest_\(guest)_host_\(host)"
    }

    static func isGuestChannel(_ channelName: String?, userId: String) -> Bool {
        channelName?.hasPrefix("Zyvoo_guest_\(userId)_host_") == true
    }

    static func isHostChannel(_ channelName: String?, userId: String) -> Bool {
        channelName?.hasSuffix("_host_\(userId)") == true
    }
}

struct FirebaseChatResult {
    let isSuccessful: Bool
    let error: Error?
    let resultText: String?

    static let success = FirebaseChatResult(isSuccessful: true, error: nil, resultText: nil)
    static func failure(_ error: Error) -> FirebaseChatResult {
        FirebaseChatResult(isSuccessful: false, error: error, resultText: error.localizedDescription)
    }
}

private struct FirebaseChatError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

final class FirebaseChatMedia {
    private let remoteURL: URL
    init(remoteURL: URL) { self.remoteURL = remoteURL }
    func getTemporaryContentUrl(completion: @escaping (FirebaseChatResult, URL?) -> Void) {
        completion(.success, remoteURL)
    }
}

final class FirebaseChatMessage: Hashable {
    let sid: String?
    let body: String?
    let author: String?
    let dateCreated: String?
    let dateUpdated: String?
    let index: NSNumber?
    let attachedMedia: [FirebaseChatMedia]
    fileprivate let createdAt: Date

    init(sid: String = UUID().uuidString, body: String? = nil, author: String? = nil,
         createdAt: Date = Date(), mediaURL: URL? = nil) {
        self.sid = sid
        self.body = body
        self.author = author
        self.createdAt = createdAt
        let isoDate = FirebaseChatDateFormatter.string(from: createdAt)
        self.dateCreated = isoDate
        self.dateUpdated = isoDate
        self.index = NSNumber(value: Int64(createdAt.timeIntervalSince1970 * 1_000))
        self.attachedMedia = mediaURL.map { [FirebaseChatMedia(remoteURL: $0)] } ?? []
    }

    static func == (lhs: FirebaseChatMessage, rhs: FirebaseChatMessage) -> Bool { lhs.sid == rhs.sid }
    func hash(into hasher: inout Hasher) { hasher.combine(sid) }
}

final class FirebaseChatParticipant {
    let identity: String?
    var lastReadTimestamp: String?
    var lastReadMessageIndex: NSNumber?
    init(identity: String) { self.identity = identity }
}

final class FirebaseChatUser {
    let identity: String
    private let online: Bool
    init(identity: String, online: Bool) { self.identity = identity; self.online = online }
    func isOnline() -> Bool { online }
    func attributes() -> Any { [:] }
}

protocol FirebaseChatConversationDelegate: AnyObject {
    func conversation(_ conversation: FirebaseChatConversation, participantJoined participant: FirebaseChatParticipant)
    func conversation(_ conversation: FirebaseChatConversation, participantLeft participant: FirebaseChatParticipant)
    func conversation(_ conversation: FirebaseChatConversation, messageAdded message: FirebaseChatMessage)
}

extension FirebaseChatConversationDelegate {
    func conversation(_ conversation: FirebaseChatConversation, participantJoined participant: FirebaseChatParticipant) {}
    func conversation(_ conversation: FirebaseChatConversation, participantLeft participant: FirebaseChatParticipant) {}
    func conversation(_ conversation: FirebaseChatConversation, messageAdded message: FirebaseChatMessage) {}
}

final class FirebaseChatConversation: Hashable {
    let uniqueName: String?
    fileprivate let participantIds: [String]
    fileprivate weak var manager: FirebaseChatManager?
    fileprivate var cachedMessages: [FirebaseChatMessage] = []
    fileprivate(set) var lastMessageDate: Date?
    weak var delegate: FirebaseChatConversationDelegate?

    init(name: String, participantIds: [String], manager: FirebaseChatManager, lastMessageDate: Date? = nil) {
        self.uniqueName = name
        self.participantIds = participantIds
        self.manager = manager
        self.lastMessageDate = lastMessageDate
    }

    var lastMessageIndex: NSNumber? {
        cachedMessages.last?.index ?? lastMessageDate.map { NSNumber(value: Int64($0.timeIntervalSince1970 * 1_000)) }
    }

    func getUnreadMessagesCount(completion: @escaping (FirebaseChatResult, NSNumber?) -> Void) {
        manager?.unreadCount(for: self, completion: completion)
    }

    func message(withIndex index: NSNumber, completion: @escaping (FirebaseChatResult, FirebaseChatMessage?) -> Void) {
        if let message = cachedMessages.first(where: { $0.index == index }) ?? cachedMessages.last {
            completion(.success, message)
        } else {
            manager?.fetchLastMessage(for: self, completion: completion)
        }
    }

    func setLastReadMessageIndex(_ index: NSNumber, completion: @escaping (FirebaseChatResult, NSNumber?) -> Void) {
        manager?.markRead(conversation: self) { result in completion(result, index) }
    }

    func getMessagesBefore(_ index: UInt, withCount count: UInt,
                           completion: @escaping (FirebaseChatResult, [FirebaseChatMessage]?) -> Void) {
        manager?.loadOlderMessages(for: self, count: Int(count), completion: completion)
    }

    func typing() { manager?.sendTyping(in: self) }
    func participants() -> [FirebaseChatParticipant] { participantIds.map(FirebaseChatParticipant.init(identity:)) }
    func participant(withIdentity identity: String) -> FirebaseChatParticipant? {
        participantIds.contains(identity) ? FirebaseChatParticipant(identity: identity) : nil
    }
    func leave(completion: @escaping (FirebaseChatResult) -> Void) { completion(.success) }
    func destroy(completion: @escaping (FirebaseChatResult) -> Void) { completion(.success) }
    static func == (lhs: FirebaseChatConversation, rhs: FirebaseChatConversation) -> Bool { lhs.uniqueName == rhs.uniqueName }
    func hash(into hasher: inout Hasher) { hasher.combine(uniqueName) }
}

final class FirebaseChatClient {
    fileprivate weak var manager: FirebaseChatManager?
    init(manager: FirebaseChatManager) { self.manager = manager }
    func myConversations() -> [FirebaseChatConversation]? { manager?.allConversations }

    func conversation(withSidOrUniqueName name: String,
                      completion: @escaping (FirebaseChatResult, FirebaseChatConversation?) -> Void) {
        if let item = manager?.allConversations.first(where: { $0.uniqueName == name }) {
            completion(.success, item)
        } else {
            completion(.failure(FirebaseChatError(message: "Conversation not found.")), nil)
        }
    }

    func subscribedUser(withIdentity identity: String,
                        completion: @escaping (FirebaseChatResult, FirebaseChatUser?) -> Void) {
        manager?.userStatus(userId: identity, completion: completion)
    }
}

protocol FirebaseChatManagerDelegate: AnyObject {
    func getClient(client: FirebaseChatClient?)
    func reloadMessages()
    func receivedNewMessage(message: FirebaseChatMessage)
    func displayStatusMessage(_ statusMessage: String)
    func displayErrorMessage(_ errorMessage: String)
    func startTyping(participant: FirebaseChatParticipant)
    func endTyping(participant: FirebaseChatParticipant)
}

typealias BackendChatMediaUploader = (Data, String, String, @escaping (Result<URL, Error>) -> Void) -> Void

final class FirebaseChatManager: NSObject {
    static let shared = FirebaseChatManager()

    weak var delegate: FirebaseChatManagerDelegate?
    private(set) var messages: [FirebaseChatMessage] = []
    private(set) var client: FirebaseChatClient?
    private(set) var conversation: FirebaseChatConversation?
    var myConversationon: ((FirebaseChatClient?) -> Void)?
    var myMsg: ((FirebaseChatMessage?) -> Void)?
    var onConversationReady: (() -> Void)?

    /// Configure this closure with the backend upload API. Only its returned URL
    /// is stored in Firestore.
    var backendMediaUploader: BackendChatMediaUploader?

    fileprivate var allConversations: [FirebaseChatConversation] = []
    // Keep Firestore lazy: AppDelegate and view-controller stored properties can
    // reference the singleton before didFinishLaunching configures Firebase.
    private lazy var database = Firestore.firestore()
    private let channelsCollection = "chat_channels"
    private let messagesCollection = "messages"
    private let membersCollection = "members"
    private let presenceCollection = "chat_presence"
    private var channelListener: ListenerRegistration?
    private var messageListener: ListenerRegistration?
    private var typingListener: ListenerRegistration?
    private var typingEndWorkItem: DispatchWorkItem?
    private var presenceTimer: Timer?
    private var initialMessagesDelivered = false
    private var partnerWasTyping = false
    private var deletionBoundaries: [String: Date] = [:]
    private var messageObservationID = UUID()

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    /// Temporary source-compatible entry point while old token calls are removed.
    /// Firestore does not use the Twilio token argument.
    func loginWithAccessToken(_ token: String, completion: @escaping (FirebaseChatClient?) -> Void) {
        connect(completion: completion)
    }

    func connect(completion: @escaping (FirebaseChatClient?) -> Void = { _ in }) {
        let userId = UserDetail.shared.getUserId()
        guard !userId.isEmpty else { completion(nil); return }
        if client == nil { client = FirebaseChatClient(manager: self) }
        observeChannels(for: userId)
        startPresenceHeartbeat()
        completion(client)
    }

    func cleanupFirebase() {
        channelListener?.remove(); messageListener?.remove(); typingListener?.remove()
        typingEndWorkItem?.cancel()
        presenceTimer?.invalidate()
        channelListener = nil; messageListener = nil; typingListener = nil; presenceTimer = nil
        typingEndWorkItem = nil
        updatePresence(active: false)
        client = nil; conversation = nil; messages = []; allConversations = []
    }

    @available(*, deprecated, message: "Use cleanupFirebase().")
    func cleanupTwilio() { cleanupFirebase() }

    func leaveActiveChat() {
        messageObservationID = UUID()
        messageListener?.remove()
        messageListener = nil
        typingListener?.remove()
        typingListener = nil
        typingEndWorkItem?.cancel()
        typingEndWorkItem = nil
        partnerWasTyping = false
        conversation = nil
        messages = []
        initialMessagesDelivered = false
        NotificationCenter.default.post(name: NSNotification.Name("UpdateUnreadBadge"), object: nil)
    }

    /// Records a private history boundary without removing shared messages.
    func markChatDeletedForCurrentUser(channelName: String,
                                       completion: ((FirebaseChatResult) -> Void)? = nil) {
        let userId = UserDetail.shared.getUserId()
        guard !userId.isEmpty, !channelName.isEmpty else {
            completion?(.failure(FirebaseChatError(message: "Unable to save the deleted chat state.")))
            return
        }
        let firestoreChannelName = canonicalChannelName(from: channelName)
        let boundary = Date()
        memberReference(channelName: firestoreChannelName, userId: userId).setData([
            "user_id": userId,
            "deleted_before": Timestamp(date: boundary),
            "is_deleted": true,
            "unread_count": 0
        ], merge: true) { [weak self] error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            self?.deletionBoundaries[firestoreChannelName] = boundary
            completion?(.success)
            NotificationCenter.default.post(name: NSNotification.Name("UpdateUnreadBadge"), object: nil)
        }
    }

    func loadChat(uniqueConversationName: String, friendIdentity: String) {
        let userId = UserDetail.shared.getUserId()
        guard !userId.isEmpty, !friendIdentity.isEmpty else {
            delegate?.displayErrorMessage("Unable to open chat because a user ID is missing.")
            return
        }
        connect()
        let canonicalName = uniqueConversationName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !canonicalName.isEmpty else {
            delegate?.displayErrorMessage("Unable to open chat because its channel name is missing.")
            return
        }
        let participants = [userId, friendIdentity].sorted()
        let channelReference = database.collection(channelsCollection).document(canonicalName)
        channelReference.setData([
            "channel_name": canonicalName,
            "participant_ids": participants,
            "updated_at": FieldValue.serverTimestamp()
        ], merge: true) { [weak self] error in
            guard let self = self else { return }
            if let error = error { self.delegate?.displayErrorMessage(error.localizedDescription); return }
            self.ensureMemberDocuments(channelReference: channelReference, participantIds: participants)
            let selected = self.allConversations.first(where: { $0.uniqueName == canonicalName })
                ?? FirebaseChatConversation(name: canonicalName, participantIds: participants, manager: self)
            // Never render cached channel summaries while the per-user deletion
            // boundary is being resolved.
            self.messages = []
            selected.cachedMessages = []
            self.conversation = selected
            DispatchQueue.main.async { self.delegate?.reloadMessages() }
            self.observeMessages(in: selected)
            self.observeTyping(in: selected, friendIdentity: friendIdentity)
        }
    }

    func sendMessage(_ messageText: String,
                     completion: @escaping (FirebaseChatResult, FirebaseChatMessage?) -> Void) {
        sendMessage(body: messageText, mediaURL: nil, mediaType: "text", completion: completion)
    }

    func sendMediaMessage(data: Data, contentType: String, fileName: String,
                          completion: @escaping (FirebaseChatResult?, FirebaseChatMessage?) -> Void) {
        let uploader = backendMediaUploader ?? uploadChatMedia
        uploader(data, contentType, fileName) { [weak self] result in
            switch result {
            case .success(let url):
                self?.sendMediaMessage(mediaURL: url, contentType: contentType, fileName: fileName, completion: completion)
            case .failure(let error): completion(.failure(error), nil)
            }
        }
    }

    /// Uploads the binary to the app backend. Firestore receives only the URL,
    /// keeping message documents small and realtime listeners fast.
    private func uploadChatMedia(data: Data, contentType: String, fileName: String,
                                 completion: @escaping (Result<URL, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
            "Accept": "application/json",
            "Timezone": TimeZone.current.identifier
        ]

        AF.upload(multipartFormData: { formData in
            formData.append(data, withName: "file", fileName: fileName, mimeType: contentType)
        }, to: AppURL.baseURL + "upload_chat_media", headers: headers)
        .validate(statusCode: 200..<300)
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let responseData):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                          (json["success"] as? Bool) == true,
                          let payload = json["data"] as? [String: Any],
                          let mediaPath = payload["media_path"] as? String,
                          let mediaURL = Self.absoluteMediaURL(from: mediaPath) else {
                        throw FirebaseChatError(message: "The media upload response did not contain a valid URL.")
                    }
                    completion(.success(mediaURL))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func absoluteMediaURL(from mediaPath: String) -> URL? {
        let cleanedPath = mediaPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedPath.isEmpty else { return nil }
        if let url = URL(string: cleanedPath), url.scheme != nil { return url }
        let relativePath = cleanedPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: AppURL.imageURL + relativePath)
    }

    func sendMediaMessage(mediaURL: URL, contentType: String, fileName: String,
                          completion: @escaping (FirebaseChatResult, FirebaseChatMessage?) -> Void) {
        sendMessage(body: nil, mediaURL: mediaURL, mediaType: contentType,
                    fileName: fileName, completion: completion)
    }

    func shutdown() { cleanupFirebase() }

    func checkFirebaseUserStatus(userId: String, completion: @escaping (String) -> Void) {
        userStatus(userId: userId) { result, user in
            guard result.isSuccessful, let user = user else { completion("Unable to fetch user status"); return }
            completion(user.isOnline() ? "\(user.identity) is Online" : "\(user.identity) is offline")
        }
    }

    @available(*, deprecated, message: "Use checkFirebaseUserStatus(userId:completion:).")
    func checkTwilioUserStatus(userId: String, completion: @escaping (String) -> Void) {
        checkFirebaseUserStatus(userId: userId, completion: completion)
    }

    func lastReadTime(conversation: FirebaseChatConversation, identity: String) -> String {
        conversation.participant(withIdentity: identity)?.lastReadTimestamp ?? ""
    }

    fileprivate func unreadCount(for conversation: FirebaseChatConversation,
                                 completion: @escaping (FirebaseChatResult, NSNumber?) -> Void) {
        guard let name = conversation.uniqueName else {
            completion(.failure(FirebaseChatError(message: "Missing channel name.")), nil); return
        }
        if self.conversation?.uniqueName == name {
            completion(.success, 0)
            return
        }
        let userId = UserDetail.shared.getUserId()
        memberReference(channelName: name, userId: userId).getDocument { snapshot, error in
            if let error = error { completion(.failure(error), nil); return }
            completion(.success, snapshot?.data()?["unread_count"] as? NSNumber ?? 0)
        }
    }

    fileprivate func markRead(conversation: FirebaseChatConversation,
                              completion: @escaping (FirebaseChatResult) -> Void) {
        guard let name = conversation.uniqueName else {
            completion(.failure(FirebaseChatError(message: "Missing channel name."))); return
        }
        let userId = UserDetail.shared.getUserId()
        memberReference(channelName: name, userId: userId).setData([
            "unread_count": 0,
            "last_read_at": FieldValue.serverTimestamp(),
            "user_id": userId
        ], merge: true) { error in
            completion(error.map(FirebaseChatResult.failure) ?? .success)
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name("UpdateUnreadBadge"), object: nil)
            }
        }
    }

    fileprivate func fetchLastMessage(for conversation: FirebaseChatConversation,
                                      completion: @escaping (FirebaseChatResult, FirebaseChatMessage?) -> Void) {
        guard let name = conversation.uniqueName else {
            completion(.failure(FirebaseChatError(message: "Missing channel name.")), nil); return
        }
        database.collection(channelsCollection).document(name).collection(messagesCollection)
            .order(by: "created_at", descending: true).limit(to: 1)
            .getDocuments { [weak self] snapshot, error in
                if let error = error { completion(.failure(error), nil); return }
                let item = snapshot?.documents.first.flatMap { document in
                    self?.message(from: document)
                }
                if let item = item { conversation.cachedMessages = [item] }
                completion(.success, item)
            }
    }

    fileprivate func loadOlderMessages(for conversation: FirebaseChatConversation, count: Int,
                                       completion: @escaping (FirebaseChatResult, [FirebaseChatMessage]?) -> Void) {
        guard let name = conversation.uniqueName else {
            completion(.failure(FirebaseChatError(message: "Missing channel name.")), nil); return
        }
        var query: Query = database.collection(channelsCollection).document(name).collection(messagesCollection)
            .order(by: "created_at", descending: true).limit(to: max(1, min(count, 100)))
        if let deletedBefore = deletionBoundaries[name] {
            query = query.whereField("created_at", isGreaterThan: Timestamp(date: deletedBefore))
        }
        if let oldest = conversation.cachedMessages.first?.createdAt {
            query = query.start(after: [Timestamp(date: oldest)])
        }
        query.getDocuments { [weak self] snapshot, error in
            if let error = error { completion(.failure(error), nil); return }
            let parsed = snapshot?.documents.compactMap { self?.message(from: $0) } ?? []
            let older = Array(parsed.reversed())
            conversation.cachedMessages = older + conversation.cachedMessages
            completion(.success, older)
        }
    }

    fileprivate func sendTyping(in conversation: FirebaseChatConversation) {
        guard let name = conversation.uniqueName else { return }
        let userId = UserDetail.shared.getUserId()
        memberReference(channelName: name, userId: userId).setData([
            "user_id": userId,
            "typing_until": Timestamp(date: Date().addingTimeInterval(5)),
            "last_active_at": FieldValue.serverTimestamp()
        ], merge: true)
        updatePresence(active: true)
    }

    fileprivate func userStatus(userId: String,
                                completion: @escaping (FirebaseChatResult, FirebaseChatUser?) -> Void) {
        database.collection(presenceCollection).document(safeDocumentID(userId)).getDocument { snapshot, error in
            if let error = error { completion(.failure(error), nil); return }
            let activeUntil = (snapshot?.data()?["active_until"] as? Timestamp)?.dateValue() ?? .distantPast
            completion(.success, FirebaseChatUser(identity: userId, online: activeUntil > Date()))
        }
    }

    private func observeChannels(for userId: String) {
        channelListener?.remove()
        channelListener = database.collection(channelsCollection)
            .whereField("participant_ids", arrayContains: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error { self.delegate?.displayErrorMessage(error.localizedDescription); return }
                let previousDates: [String: Date] = Dictionary(uniqueKeysWithValues: self.allConversations.compactMap {
                    guard let name = $0.uniqueName, let date = $0.lastMessageDate else { return nil }
                    return (name, date)
                })
                self.allConversations = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let participants = data["participant_ids"] as? [String] ?? []
                    let lastDate = (data["last_message_at"] as? Timestamp)?.dateValue()
                    let item = self.allConversations.first(where: { $0.uniqueName == document.documentID })
                        ?? FirebaseChatConversation(name: document.documentID, participantIds: participants,
                                                    manager: self, lastMessageDate: lastDate)
                    item.lastMessageDate = lastDate
                    if let lastDate = lastDate {
                        item.cachedMessages = [FirebaseChatMessage(
                            sid: data["last_message_id"] as? String ?? document.documentID,
                            body: data["last_message"] as? String,
                            author: data["last_sender_id"] as? String,
                            createdAt: lastDate,
                            mediaURL: (data["last_media_url"] as? String).flatMap(Self.absoluteMediaURL(from:))
                        )]
                    }
                    return item
                }.sorted { ($0.lastMessageDate ?? .distantPast) > ($1.lastMessageDate ?? .distantPast) } ?? []
                DispatchQueue.main.async {
                    self.delegate?.getClient(client: self.client)
                    self.myConversationon?(self.client)
                    for item in self.allConversations {
                        guard let name = item.uniqueName, let date = item.lastMessageDate,
                              let oldDate = previousDates[name], date > oldDate,
                              name != self.conversation?.uniqueName,
                              let message = item.cachedMessages.last else { continue }
                        self.myMsg?(message)
                        self.delegate?.receivedNewMessage(message: message)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateUnreadBadge"), object: nil)
                }
            }
    }

    private func observeMessages(in conversation: FirebaseChatConversation) {
        guard let name = conversation.uniqueName else { return }
        let observationID = UUID()
        messageObservationID = observationID
        messageListener?.remove()
        initialMessagesDelivered = false
        let userId = UserDetail.shared.getUserId()
        memberReference(channelName: name, userId: userId).getDocument { [weak self, weak conversation] snapshot, error in
            guard let self = self, let conversation = conversation,
                  self.messageObservationID == observationID,
                  self.conversation?.uniqueName == name else { return }
            if let error = error {
                self.delegate?.displayErrorMessage(error.localizedDescription)
                return
            }
            let boundary = (snapshot?.data()?["deleted_before"] as? Timestamp)?.dateValue()
            if let boundary = boundary {
                self.deletionBoundaries[name] = boundary
            } else {
                self.deletionBoundaries.removeValue(forKey: name)
            }
            self.startObservingMessages(in: conversation,
                                        deletedBefore: boundary,
                                        observationID: observationID)
        }
    }

    private func startObservingMessages(in conversation: FirebaseChatConversation,
                                        deletedBefore: Date?,
                                        observationID: UUID) {
        guard let name = conversation.uniqueName else { return }
        var query: Query = database.collection(channelsCollection).document(name).collection(messagesCollection)
            .order(by: "created_at", descending: false)
        if let deletedBefore = deletedBefore {
            query = query.whereField("created_at", isGreaterThan: Timestamp(date: deletedBefore))
        }
        messageListener = query.limit(toLast: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard self.messageObservationID == observationID,
                      self.conversation?.uniqueName == name else { return }
                if let error = error { self.delegate?.displayErrorMessage(error.localizedDescription); return }
                let loaded = snapshot?.documents.compactMap(self.message(from:)) ?? []
                let oldIds = Set(self.messages.compactMap(\.sid))
                self.messages = loaded
                conversation.cachedMessages = loaded
                conversation.lastMessageDate = loaded.last?.createdAt
                DispatchQueue.main.async {
                    self.delegate?.reloadMessages()
                    if !self.initialMessagesDelivered {
                        self.initialMessagesDelivered = true
                        self.markRead(conversation: conversation) { _ in }
                        self.onConversationReady?()
                        return
                    }
                    let currentUserId = UserDetail.shared.getUserId()
                    let hasNewIncomingMessage = loaded.contains {
                        !oldIds.contains($0.sid ?? "") && $0.author != currentUserId
                    }
                    if hasNewIncomingMessage && self.conversation?.uniqueName == conversation.uniqueName {
                        self.markRead(conversation: conversation) { _ in }
                    }
                    for message in loaded where !oldIds.contains(message.sid ?? "") {
                        self.myMsg?(message)
                        self.delegate?.receivedNewMessage(message: message)
                        conversation.delegate?.conversation(conversation, messageAdded: message)
                    }
                }
            }
    }

    private func observeTyping(in conversation: FirebaseChatConversation, friendIdentity: String) {
        guard let name = conversation.uniqueName else { return }
        typingListener?.remove(); typingEndWorkItem?.cancel(); partnerWasTyping = false
        typingListener = memberReference(channelName: name, userId: friendIdentity)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else { return }
                let until = (snapshot?.data()?["typing_until"] as? Timestamp)?.dateValue() ?? .distantPast
                let isTyping = until > Date()
                let participant = FirebaseChatParticipant(identity: friendIdentity)
                DispatchQueue.main.async {
                    self.typingEndWorkItem?.cancel()
                    if isTyping {
                        if !self.partnerWasTyping {
                            self.partnerWasTyping = true
                            self.delegate?.startTyping(participant: participant)
                        }
                        let endWorkItem = DispatchWorkItem { [weak self] in
                            guard let self = self, self.partnerWasTyping else { return }
                            self.partnerWasTyping = false
                            self.delegate?.endTyping(participant: participant)
                        }
                        self.typingEndWorkItem = endWorkItem
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + max(0, until.timeIntervalSinceNow) + 0.1,
                            execute: endWorkItem
                        )
                    } else if self.partnerWasTyping {
                        self.partnerWasTyping = false
                        self.delegate?.endTyping(participant: participant)
                    }
                }
            }
    }

    private func sendMessage(body: String?, mediaURL: URL?, mediaType: String, fileName: String? = nil,
                             completion: @escaping (FirebaseChatResult, FirebaseChatMessage?) -> Void) {
        guard let conversation = conversation, let name = conversation.uniqueName else {
            completion(.failure(FirebaseChatError(message: "Conversation is not ready.")), nil); return
        }
        let senderId = UserDetail.shared.getUserId()
        let channelRef = database.collection(channelsCollection).document(name)
        let messageRef = channelRef.collection(messagesCollection).document()
        let localMessage = FirebaseChatMessage(sid: messageRef.documentID, body: body,
                                               author: senderId, mediaURL: mediaURL)
        var messageData: [String: Any] = [
            "sender_id": senderId,
            "type": mediaURL == nil ? "text" : "media",
            "media_type": mediaType,
            "created_at": FieldValue.serverTimestamp()
        ]
        if let body = body { messageData["text"] = body }
        if let mediaURL = mediaURL { messageData["media_url"] = mediaURL.absoluteString }
        if let fileName = fileName { messageData["file_name"] = fileName }
        var channelData: [String: Any] = [
            "channel_name": name,
            "participant_ids": conversation.participantIds,
            "last_message_id": messageRef.documentID,
            "last_message": body ?? "Photo",
            "last_sender_id": senderId,
            "last_message_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ]
        if let mediaURL = mediaURL { channelData["last_media_url"] = mediaURL.absoluteString }
        let batch = database.batch()
        batch.setData(messageData, forDocument: messageRef)
        batch.setData(channelData, forDocument: channelRef, merge: true)
        for receiverId in conversation.participantIds where receiverId != senderId {
            batch.setData(["user_id": receiverId, "unread_count": FieldValue.increment(Int64(1))],
                          forDocument: memberReference(channelName: name, userId: receiverId), merge: true)
        }
        // Re-show the conversation for the sender while retaining deleted_before,
        // which keeps their previous history hidden.
        batch.setData(["user_id": senderId, "is_deleted": false],
                      forDocument: memberReference(channelName: name, userId: senderId), merge: true)
        batch.commit { error in
            if let error = error { completion(.failure(error), nil) }
            else { completion(.success, localMessage) }
        }
    }

    private func ensureMemberDocuments(channelReference: DocumentReference, participantIds: [String]) {
        let batch = database.batch()
        for userId in participantIds {
            // Do not write unread_count here: opening a chat must not erase the
            // other participant's unread messages. Increment creates it on demand.
            batch.setData(["user_id": userId],
                          forDocument: channelReference.collection(membersCollection).document(safeDocumentID(userId)),
                          merge: true)
        }
        batch.commit()
    }

    private func memberReference(channelName: String, userId: String) -> DocumentReference {
        database.collection(channelsCollection).document(channelName)
            .collection(membersCollection).document(safeDocumentID(userId))
    }

    private func message(from document: QueryDocumentSnapshot) -> FirebaseChatMessage? {
        let data = document.data()
        return FirebaseChatMessage(
            sid: document.documentID,
            body: data["text"] as? String,
            author: data["sender_id"] as? String,
            createdAt: (data["created_at"] as? Timestamp)?.dateValue() ?? Date(),
            mediaURL: (data["media_url"] as? String).flatMap(Self.absoluteMediaURL(from:))
        )
    }

    private func safeDocumentID(_ value: String) -> String {
        Data(value.utf8).base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
    }

    private func canonicalChannelName(from value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("Zyvoo_guest_") { return trimmed }
        let idsText = trimmed.hasPrefix("Zyvoo_") ? String(trimmed.dropFirst("Zyvoo_".count)) : trimmed
        let ids = idsText.split(whereSeparator: { $0 == "_" || $0 == "*" }).map(String.init)
        guard ids.count == 2 else { return trimmed.replacingOccurrences(of: "*", with: "_") }
        return "Zyvoo_\([ids[0], ids[1]].sorted().joined(separator: "_"))"
    }

    private func startPresenceHeartbeat() {
        presenceTimer?.invalidate(); updatePresence(active: true)
        presenceTimer = Timer.scheduledTimer(withTimeInterval: 25, repeats: true) { [weak self] _ in
            self?.updatePresence(active: true)
        }
    }

    private func updatePresence(active: Bool) {
        let userId = UserDetail.shared.getUserId()
        guard !userId.isEmpty else { return }
        database.collection(presenceCollection).document(safeDocumentID(userId)).setData([
            "user_id": userId,
            "active_until": Timestamp(date: active ? Date().addingTimeInterval(60) : Date()),
            "last_seen_at": FieldValue.serverTimestamp()
        ], merge: true)
    }

    @objc private func applicationDidBecomeActive() {
        if !UserDetail.shared.getUserId().isEmpty { connect() }
    }

    @objc private func applicationWillResignActive() {
        presenceTimer?.invalidate(); presenceTimer = nil; updatePresence(active: false)
    }
}

private enum FirebaseChatDateFormatter {
    private static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    static func string(from date: Date) -> String { formatter.string(from: date) }
}

struct ChatMessage {
    var text: String?
    var imageUrl: String?
}

// Temporary aliases keep the existing host/guest controllers source-compatible
// while their transport is now entirely Firestore-backed.
typealias QuickstartConversationsManager = FirebaseChatManager
typealias QuickstartConversationsManagerDelegate = FirebaseChatManagerDelegate
typealias TwilioConversationsClient = FirebaseChatClient
typealias TCHConversation = FirebaseChatConversation
typealias TCHConversationDelegate = FirebaseChatConversationDelegate
typealias TCHParticipant = FirebaseChatParticipant
typealias TCHMessage = FirebaseChatMessage
typealias TCHResult = FirebaseChatResult
