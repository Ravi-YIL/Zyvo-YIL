

import Foundation
import TwilioConversationsClient


struct get_message_listModel : Codable {
       let message: String?
       let success: Bool?
       let code: Int?
	   let friends_data : [Friends_data]?

	enum CodingKeys: String, CodingKey {
        case message
        case success
        case code
		case friends_data = "data"
	}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.friends_data = try container.decodeIfPresent([Friends_data].self, forKey: .friends_data)
    }
	

}
struct Friends_data : Codable {
    
    let profile : String?
    let user_profile : String?
    let group_name : String?
    let name : String?
    let friendid : String?
    let ProviderName:String?
    let services_name:String?
    var chatData : TCHConversation?
    
    
    enum CodingKeys: String, CodingKey {

        case profile = "userProfile_image"
        case group_name = "groupChanel"
        case ProviderName = "ProviderName"
        case name = "userName"
        case friendid = "receiverId"
        case services_name = "services_name"
        case user_profile = "providerProfile_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profile = try values.decodeIfPresent(String.self, forKey: .profile)
        user_profile = try values.decodeIfPresent(String.self, forKey: .user_profile)
        group_name = try values.decodeIfPresent(String.self, forKey: .group_name)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        ProviderName = try values.decodeIfPresent(String.self, forKey: .ProviderName)
        friendid = try values.decodeIfPresent(String.self, forKey: .friendid) ?? "0"
        services_name = try values.decodeIfPresent(String.self, forKey: .services_name) ?? ""
        
    }

}
