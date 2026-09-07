//
//  ChatDataModel.swift
//  Zyvo
//
//  Created by ravi on 21/03/25.
//

// MARK: - ChatDataModel
struct ChatDataModel: Codable {

    let groupName, receiverID, receiverName, receiverImage: String?
    let senderID, senderName: String?
    let senderProfile: String?
    let propertyTitle: String?

    var isFavorite: Bool?
    var isBlocked, isOtherBlocked, isMuted, isArchived: Int?
    var isDeleted: Bool?
    var unreadCount: Int = 0
    
    var chatData: TCHConversation?

    // MARK: - Cached UI Data
    var lastMessage: String? = nil
    var lastMessageTime: String? = nil
    

    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case receiverImage = "receiver_image"
        case senderID = "sender_id"
        case senderName = "sender_name"
        case senderProfile = "sender_profile"
        case propertyTitle = "property_title"
        case isBlocked = "is_blocked"
        case isOtherBlocked = "is_other_block"
        case isFavorite = "is_favorite"
        case isMuted = "is_muted"
        case isArchived = "is_archived"
        case isDeleted = "is_deleted"
        case unreadCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        groupName = try? container.decode(String.self, forKey: .groupName)
        receiverID = try? container.decode(String.self, forKey: .receiverID)
        receiverName = try? container.decode(String.self, forKey: .receiverName)
        receiverImage = try? container.decode(String.self, forKey: .receiverImage)

        senderID = try? container.decode(String.self, forKey: .senderID)
        senderName = try? container.decode(String.self, forKey: .senderName)
        senderProfile = try? container.decode(String.self, forKey: .senderProfile)
        propertyTitle = try? container.decode(String.self, forKey: .propertyTitle)

        isBlocked = try? container.decode(Int.self, forKey: .isBlocked)
        isMuted = try? container.decode(Int.self, forKey: .isMuted)
        isArchived = try? container.decode(Int.self, forKey: .isArchived)
        
        if let intValue = try? container.decode(Int.self, forKey: .unreadCount) {
            unreadCount = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .unreadCount) {
            unreadCount = Int(stringValue) ?? 0
        } else {
            unreadCount = 0
        }

        // Handle Bool or Int
        if let boolValue = try? container.decode(Bool.self, forKey: .isFavorite) {
            isFavorite = boolValue
        } else if let intValue = try? container.decode(Int.self, forKey: .isFavorite) {
            isFavorite = intValue == 1
        } else {
            isFavorite = false
        }

        isDeleted = try? container.decode(Bool.self, forKey: .isDeleted)
        chatData = nil
    }
}

// MARK: - UserBlockStatusModel
struct UserBlockStatusModel: Codable {
    let isBlocked: Int?
    let blockedTo: Int?
    let blockedBy: String?
    
    enum CodingKeys: String, CodingKey {
        case isBlocked = "is_blocked"
        case blockedTo = "blocked_to"
        case blockedBy = "blocked_by"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        blockedTo = try container.decodeIfPresent(Int.self, forKey: .blockedTo)
        blockedBy = try container.decodeIfPresent(String.self, forKey: .blockedBy)
        isBlocked = try container.decodeIfPresent(Int.self, forKey: .isBlocked)
    }
}

// MARK: - ChatFavouriteModel
struct ChatFavouriteModel: Codable {
    let message, senderID, receiverID, groupName: String?
    let favoriteStatus: String?

    enum CodingKeys: String, CodingKey {
        case message
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case groupName = "group_name"
        case favoriteStatus = "favorite_status"
    }
}

// MARK: - SetMuteUnmute
struct SetMuteUnmute: Codable {
    let mutedBy, mutedTo: String?
    let muteStatus: Int?

    enum CodingKeys: String, CodingKey {
        case mutedBy = "muted_by"
        case mutedTo = "muted_to"
        case muteStatus = "mute_status"
    }
}

// MARK: - SetArchiveUnarchiveModel
struct SetArchiveUnarchiveModel: Codable {
    let status: String?
    let isArchived: Bool?
    let archivedAt: String?

    enum CodingKeys: String, CodingKey {
        case status
        case isArchived = "is_archived"
        case archivedAt = "archived_at"
    }
}

// MARK: - UnreadBookingModel
struct unreadbookingModel: Codable {
    let unreadBookingCount: Int?

    enum CodingKeys: String, CodingKey {
        case unreadBookingCount = "unread_booking_count"
    }
}


// MARK: - Unused ChannelListModel (kept for compatibility)
struct ChannelListModel {
    let groupName: String?
    let receiverId: String?
    let receiverImage: String?
    let receiverName: String?
    let senderId: String?
    let senderName: String?
    let senderProfile: String?
    var lastMessage: String = ""
    var lastMessageTime: String = ""
    var isOnline: Bool = false
    var propertyTitle: String = ""
    var date: String = ""
    var isBlocked: Int = 0
    var isDeleted: Bool = false
    var isFavorite: Int = 0
    var isMuted: Int = 0
    var isArchived: Int = 0
}
