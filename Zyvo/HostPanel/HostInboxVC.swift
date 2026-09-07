//
//  HostInboxVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
//import KDCircularProgress
import DropDown
import Combine
import IQKeyboardManagerSwift

class HostInboxVC:UIViewController {
    
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    var Arr = ["Mute","Report","Delete chat","Block","Archive"]
    
    private var totalUnreadCount = 0
    
    var dropDown = DropDown()
    var dropDownFilter = DropDown()
    var ArrFilter = ["All Conversations","Archived","Unread"]
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    
    var index : Int? = 0
    
    private let debouncer = Debouncer()
    private var chatDataArr: [ChatDataModel] = []
    private var MainchatDataArr: [ChatDataModel] = []
    
    private var conversationsManager = QuickstartConversationsManager.shared.self
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    
    var currentStatus = ""
    var isFetched : Bool? = false
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        setupTableView()
        
        setupUI()
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        //        conversationsManager.myMsg = { msg in
        //            print(msg?.body ?? "","twillio msg from closer")
        //        }
        conversationsManager.myMsg = { [weak self] msg in
            guard let self = self else { return }
            print(msg?.body ?? "")
        }
        txt_Search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isFetched = false
        self.tblV.setEmptyView(message: "")
        self.chatDataArr.removeAll()
        self.tblV.reloadData()
    }
    
    private func setupTableView() {
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "msgCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
            print("Login with Access Token")
            self.viewModel.apiForGetChatData2(userType: "host")
        }
        self.conversationsManager.delegate = self
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        conversationsManager.delegate = self
        
    }
    
    @objc private func pullToRefresh() {
        
//        DispatchQueue.main.async {
//              GameLoaderView.show(in: self.view)
//          }
        
        APIManager.shared.apiforGetChatToken(role: "host") { t in
            let token = UserDetail.shared.getChatToken()
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                print("Login with Access Token")
                self.viewModel.apiForGetChatData2(userType: "host")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsManager.delegate = self
        IQKeyboardManager.shared.enable = true
        
                
        let token = UserDetail.shared.getChatToken()
        if isFetched == false {
//            DispatchQueue.main.async {
//                GameLoaderView.show(in:  self.view)
//            }
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                print("Login with Access Token")
             
                self.viewModel.apiForGetChatData2(userType: "host")
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.txt_Search.text?.isEmpty ?? true {
            self.chatDataArr = self.MainchatDataArr
        } else {
            self.chatDataArr = self.MainchatDataArr.filter {
                $0.senderName?.lowercased().contains(self.txt_Search.text?.lowercased() ?? "") ?? false
            }
        }
        self.tblV.reloadData() // Reload table view to reflect changes
    }
    
    @IBAction func btnFitler_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        dropDownFilter.anchorView = sender // Anchor dropdown to the button
        dropDownFilter.dataSource = ArrFilter
        dropDownFilter.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDownFilter.cornerRadius = 10
        dropDownFilter.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dropDownFilter.layer.shadowColor = UIColor.gray.cgColor
        dropDownFilter.layer.shadowOpacity = 0.2
        dropDownFilter.layer.shadowRadius = 10
        dropDownFilter.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        if let anchorHeight = dropDownFilter.anchorView?.plainView.bounds.height {
            dropDownFilter.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        // Customize cells
        dropDownFilter.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dropDownFilter.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected Value: \(item)")
            
            if "\(item)" == "Archived" {
                
                self.currentStatus = "Archived"
                
                self.chatDataArr = chatDataArr.filter { $0.isArchived == 1 }
                self.tblV.reloadData()
                
            }
            if "\(item)" == "Unread" {
                self.currentStatus = "Unread"
                getUnreadConversations { [weak self] unreadConversations in
                    guard let self = self else { return }
                    // Filter only the unread messages
                    self.chatDataArr = self.chatDataArr.filter { chat in
                        unreadConversations.contains { $0.uniqueName == chat.groupName }
                    }
                    self.tblV.reloadData() // Reload table with unread messages
                }
            }
            if "\(item)" == "All Conversations" {
                
                self.currentStatus = "All Conversations"
                
                let token = UserDetail.shared.getChatToken()
                QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                    print("Login with Access Token")
                    self.viewModel.apiForGetChatData2(userType: "host")
                }
                
            }
        }
        
        // Show dropdown
        dropDownFilter.show()
        
        
    }
    
    func getUnreadConversations(completion: @escaping ([TCHConversation]) -> Void) {
        
        var unreadConversations: [TCHConversation] = []
        
        let dispatchGroup = DispatchGroup()
        
        for conversation in self.listOfChannel {
            dispatchGroup.enter()
            conversation.getUnreadMessagesCount { (result, unreadCount) in
                if result.isSuccessful, let unread = unreadCount?.intValue, unread > 0 {
                    unreadConversations.append(conversation) // Append only unread messages
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(unreadConversations.count,"COUNT")
            completion(unreadConversations) // Return unread conversations
        }
    }

    
    private func fetchUnreadMessageCounts() {
        
        var totalUnreadCount = 0
        let group = DispatchGroup()
        
        for (index, data) in chatDataArr.enumerated() {
            
            if let conversation = data.chatData {
                
                group.enter()
                
                conversation.getUnreadMessagesCount { (_, unreadCount) in
                    
                    let unread = unreadCount?.intValue ?? 0
                    
                    // ✅ Store in chatDataArr
                    if let i = self.chatDataArr.firstIndex(where: {
                        $0.groupName == conversation.uniqueName
                    }) {
                        self.chatDataArr[i].unreadCount = unread
                    }
                    
                    // ✅ Add to total
                    totalUnreadCount += unread
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("✅ Total Unread Updated: \(totalUnreadCount)")
            
            self.totalUnreadCount = totalUnreadCount
            
            // ✅ Reload table to reflect per-cell unread count
            self.tblV.reloadData()
            
            // ✅ Send to TabBar / Badge
            NotificationCenter.default.post(
                name: NSNotification.Name("UpdateUnreadBadge"),
                object: totalUnreadCount
            )
        }
    }
}

extension HostInboxVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120// UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(chatDataArr.count,"ChatDataArr.count")
        return chatDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! msgCell
        
        let data = chatDataArr[indexPath.row]
        cell.userName.text = data.senderName ?? ""
        cell.view_online.isHidden = true
        cell.lbl_PropertyTitle.text = "(\(data.propertyTitle ?? ""))"
        let image = data.senderProfile ?? ""
        let imgURL = AppURL.imageURL + image
        cell.userImg.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
        cell.btnMenu.tag = indexPath.row
       // cell.btnDetails.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        //cell.btnDetails.addTarget(self, action: #selector(buttonDetails(_:)), for: .touchUpInside)
        cell.view_online.isHidden = true
        
        print(data.unreadCount,"row-Wise Count")
        if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
            if let lastMessageIndex = conversation.lastMessageIndex {
                conversation.message(withIndex: lastMessageIndex) { (result, message) in
                    DispatchQueue.main.async {
                        if let messageBody = message {
                            cell.lbl_message.text = messageBody.body
                            if let dateUpdated = messageBody.dateUpdated {
                                cell.lbl_time.text = self.updateLastMsgTime(dateUpdated)
                            }
                        }
                    }
                }
            }
          
        }
        cell.lbl_message.text = data.lastMessage ?? ""
        cell.lbl_time.text = data.lastMessageTime ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = chatDataArr[indexPath.row]
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "HostChatVC") as? HostChatVC {
            vc.uniqueConversationName = data.groupName ?? ""
            let userid = UserDetail.shared.getUserId()
            if userid == data.receiverID {
                vc.friend_id = data.senderID ?? ""
            } else if userid == data.senderID {
                vc.friend_id = data.receiverID ?? ""
            }
            vc.SenderID = data.senderID ?? ""
            vc.favoriteStatus = (data.isFavorite ?? false) ? 1 : 0
            //vc.favoriteStatus = data.isFavorite ??  0
            vc.isBlockStatus = data.isBlocked ?? 0
            vc.isMuteStatus = data.isMuted ?? 0
            vc.isArchiveStatus = data.isArchived ?? 0
            let hostImage = data.senderProfile ?? ""
            let guestImage = data.receiverImage ?? ""
            vc.hostProfileImg = AppURL.imageURL + hostImage
            vc.guesttProfileImg = AppURL.imageURL + guestImage
            vc.hostName = data.receiverName ?? ""
            vc.guestName = data.senderName ?? ""
            self.tabBarController?.tabBar.isHidden = true
            vc.hidesBottomBarWhenPushed = true

            vc.backAction = { str,favStatus, muteStatus, archiveStatus in
                self.chatDataArr = self.MainchatDataArr
                print("\(str) Block Status Received")
                print("\(favStatus) favStatus Received")
                print("\(muteStatus) muteStatus Received")
                print("\(archiveStatus) muteStatus Received")
                let isblockedStatus = str
                let isMuteStatus = muteStatus
                if isblockedStatus == "0" {
                    self.Arr[3] = "Block"
                    self.chatDataArr[indexPath.row].isBlocked = 0
                }
                if isblockedStatus == "1" {
                    self.Arr[3] = "Unblock"
                    self.chatDataArr[indexPath.row].isBlocked = 1
                }
                let isFavStatus = favStatus
                if isFavStatus == "0" {
                    self.chatDataArr[indexPath.row].isFavorite = false
                }
                if isFavStatus == "1" {
                    self.chatDataArr[indexPath.row].isFavorite = true
                }
                let MuteStatus = isMuteStatus
                if MuteStatus == "0" {
                    self.chatDataArr[indexPath.row].isMuted = 0
                }
                if isMuteStatus == "1" {
                    self.chatDataArr[indexPath.row].isMuted = 1
                }
                let isarchiveStatus = archiveStatus
                if isarchiveStatus == "0" {
                    self.chatDataArr[indexPath.row].isArchived = 0
                }
                if isarchiveStatus == "1" {
                    self.chatDataArr[indexPath.row].isArchived = 1
                }
                if self.currentStatus == "All Conversations" || self.currentStatus == "Archived" || self.currentStatus == "Unread" {
                    self.currentStatus = ""
                    let token = UserDetail.shared.getChatToken()
                    QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                        print("Login with Access Token")
                        self.viewModel.apiForGetChatData2(userType: "host")
                    }
                }
                self.tabBarController?.tabBar.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func buttonDetails(_ sender: UIButton) {
        let d = sender.tag
        print(d,"Index")
        let data = chatDataArr[d]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListingDetailsVC") as? ListingDetailsVC
        
        let userid = UserDetail.shared.getUserId()
        if userid == data.receiverID {
            vc?.hostid = data.senderID ?? ""
        } else if userid == data.senderID {
            vc?.hostid = data.receiverID ?? ""
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("RAVI")
        // Set up the dropdown
        let blockedStatus = chatDataArr[sender.tag].isBlocked ?? 0
        
        let muteStatus = chatDataArr[sender.tag].isMuted ?? 0
        
        let archiveStatus = chatDataArr[sender.tag].isArchived ?? 0
        
        self.index = sender.tag
        if archiveStatus == 0 {
            Arr[4] = "Archive"
        }
        if archiveStatus == 1 {
            Arr[4] = "Unarchive"
        }
        if muteStatus == 0 {
            Arr[0] = "Mute"
        }
        if muteStatus == 1 {
            Arr[0] = "Unmute"
        }
        if blockedStatus == 0 {
            Arr[3] = "Block"
        }
        if blockedStatus == 1 {
            Arr[3] = "Unblock"
        }
        dropDown.anchorView = sender // Anchor dropdown to the button
        dropDown.dataSource = Arr
        dropDown.direction = .bottom
        
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dropDown.layer.shadowColor = UIColor.gray.cgColor
        dropDown.layer.shadowOpacity = 0.2
        dropDown.layer.shadowRadius = 10
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        if let anchorHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        // Customize cells
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            print("Selected index: \(index)")
            print("Selected month: \(item)")
            
            if item == "Report" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReportViolationPopUpVc") as! HostReportViolationPopUpVc
                
                self.tabBarController?.tabBar.isHidden = true
                vc.ComingFrom = "HostChat"
                vc.groupChannel = chatDataArr[sender.tag].groupName
                vc.reporter_id = chatDataArr[sender.tag].senderID ?? ""
                vc.reported_user_id = chatDataArr[sender.tag].receiverID ?? ""
                vc.backAction = { str in
                    if str == "Cancel"{
                        self.tabBarController?.tabBar.isHidden = false
                    }
                    if str == "ReportSubmitted"{
                        let sb = UIStoryboard(name: "Host", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as! HostNotificationPopUpVC
                        vc.backAction = { str in
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                            vc.comesFrom = "ReportSubmitted"
                            vc.backCome = {
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true)
                        }
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
            
            if item == "Block" {
                print("call api for block here")
                
                if item == "Block" {
                    
                    let userid = UserDetail.shared.getUserId()

                    let senderId = chatDataArr[sender.tag].senderID ?? ""
                    let receiverId = chatDataArr[sender.tag].receiverID ?? ""

                    // Current user ke opposite user ka id nikalo
                    let otherUserId = (senderId == userid) ? receiverId : senderId

                    viewModel.apiForBlockUser(
                        senderId: userid,
                        group_channel: chatDataArr[sender.tag].groupName ?? "",
                        blockUnblock: 1
                    )
//                    let userid = UserDetail.shared.getUserId()
//                    let idds = chatDataArr[sender.tag].senderID ?? ""
//                    let iddss = chatDataArr[sender.tag].receiverID ?? ""
//                    
//                    viewModel.apiForBlockUser(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", blockUnblock: 1)
                }
            }
            if item == "Unblock" {
                print("call api for unblock here")
                
                if item == "Unblock" {
                    let userid = UserDetail.shared.getUserId()

                    let senderId = chatDataArr[sender.tag].senderID ?? ""
                    let receiverId = chatDataArr[sender.tag].receiverID ?? ""

                    // Current user ke opposite user ka id nikalo
                    let otherUserId = (senderId == userid) ? receiverId : senderId

                    viewModel.apiForBlockUser(
                        senderId: userid,
                        group_channel: chatDataArr[sender.tag].groupName ?? "",
                        blockUnblock: 0
                    )
                }
            }
            if item == "Mute" {
                viewModel.apiForSetMuteUnmute(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", mute: "1")
            }
            if item == "Unmute" {
                viewModel.apiForSetMuteUnmute(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "", mute: "0")
            }
            if item == "Archive" {
                viewModel.apiForSetArchiveUnarchive(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "")
            }
            if item == "Unarchive" {
                viewModel.apiForSetArchiveUnarchive(senderId: chatDataArr[sender.tag].senderID ?? "", group_channel: chatDataArr[sender.tag].groupName ?? "")
            }
            if item == "Delete chat" {
                leaveConversation(groupName: chatDataArr[sender.tag].groupName ?? "") { success, errorMessage in
                    if success {
                        print("TESTING: Chat deleted successfully.")
                        // Find the index of the chat to delete
                        if self.chatDataArr.firstIndex(where: { $0.groupName == self.chatDataArr[sender.tag].groupName }) != nil {
                            self.viewModel.apiForDeleteChat(userType: "host", groupChannel: self.chatDataArr[sender.tag].groupName ?? "")
                        }
                    } else {
                        print("TESTING: Failed to delete chat. Error: \(errorMessage ?? "Unknown error")")
                    }
                }
            }
        }
        // Show dropdown
        dropDown.show()
    }
    
    func leaveConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }
        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.leave { status in
                    if status.isSuccessful {
                        print("Successfully left the conversation.")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while leaving conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }
    
    func deleteConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }
        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.destroy { status in
                    if status.isSuccessful {
                        print("YES CHAT DELETED")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while deleting conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }
    
}

extension HostInboxVC {
    func updateLastMsgTime(_ time: String) -> String {
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let theFirstDate = Date()
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: theSecondDate, to: theFirstDate)
            
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            } else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            } else
            
            if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            } else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            } else if let theNumbe = theComponents.minute, theNumbe > 0 {
                return "\(theNumbe)m ago"
            } else if let theNumbe = theComponents.second, theNumbe > 0 {
                return "\(theNumbe)s ago"
            } else {
                return "now"
            }
        }
        return ""
    }
    
    //    func updateLastMsgTime(_ date: Date) -> String
}



extension HostInboxVC: QuickstartConversationsManagerDelegate {
    
    func reloadAllData() {
        
        debouncer.debounce(0.0) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let group = DispatchGroup()
                
                for i in 0..<self.chatDataArr.count {
                    
                    let name = self.chatDataArr[i].groupName
                    
                    if let conversation = self.listOfChannel.first(where: { $0.uniqueName == name }) {
                        
                        self.chatDataArr[i].chatData = conversation
                        
                        if let lastIndex = conversation.lastMessageIndex {
                            
                            group.enter()
                            
                            conversation.message(withIndex: lastIndex) { result, message in
                                
                                if let msg = message {
                                    
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        
                                        // ✅ Index safe check
                                        guard self.chatDataArr.indices.contains(i) else { return }
                                        
                                        // ✅ LAST MESSAGE
                                        self.chatDataArr[i].lastMessage = msg.body ?? ""
                                        
                                        // ✅ LAST MESSAGE TIME
                                        if let date = msg.dateUpdated ?? msg.dateCreated {
                                            self.chatDataArr[i].lastMessageTime = self.updateLastMsgTime(date)
                                        } else {
                                            self.chatDataArr[i].lastMessageTime = ""
                                        }
                                    }
                                }
                                
                                group.leave()
                            }
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    
                    self.chatDataArr.sort {
                        ($0.chatData?.lastMessageDate ?? Date.distantPast) >
                        ($1.chatData?.lastMessageDate ?? Date.distantPast)
                    }
                    
                    self.tblV.reloadData()
                    //  IMPORTANT
                    //self.fetchUnreadMessageCounts()
                    
                    NotificationCenter.default.post(
                        name: NSNotification.Name("UpdateUnreadBadge"),
                        object: nil
                    )
                }
            }
        }
    }
    func displayStatusMessage(_ statusMessage: String) {
        print(statusMessage)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("Start Typing")
    }
    
    func endTyping(participant: TCHParticipant) {
        print("End Typing")
    }
    
    func getClient(client: TwilioConversationsClient?) {
        if let client = client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData2(userType: "host")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                //  self.fetchUnreadMessageCounts()
                self.reloadAllData()
                NotificationCenter.default.post(
                    name: NSNotification.Name("UpdateUnreadBadge"),
                    object: nil
                )
            }
        }
    }
}

extension HostInboxVC {
    func bindVC() {
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    let arr = response.data ?? []
                    
                    //   self.chatDataArr = arr.filter { $0.isDeleted == false && $0.propertyTitle != ""}
                    self.chatDataArr = arr //.filter { $0.isDeleted == false }
                    self.MainchatDataArr = self.chatDataArr
                    
                    if self.chatDataArr.count == 0 {
                        self.tblV.setEmptyView(message: "No Conversation Found.")
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() ){
                        
                        self.reloadAllData()
                       // GameLoaderView.hide(from: self.view)
                        self.refreshControl.endRefreshing()
                    }
                })
            }.store(in: &cancellables)
        
        // Result Block api
        viewModel.$blockResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    let isblockedStatus = response.data?.isBlocked ?? 0
                    print(response.message ?? "")
                    print(isblockedStatus,"isblockedStatus")
                    if isblockedStatus == 1 {
                        self.Arr[3] = "Unblock"
                        self.showToast("You have blocked this user.")
                        self.chatDataArr[self.index ?? 0].isBlocked = 1
                    }
                    if isblockedStatus == 0 {
                        self.Arr[3] = "Block"
                        self.showToast("You have unblocked this user.")
                        self.chatDataArr[self.index ?? 0].isBlocked = 0
                    }
                    
                })
            }.store(in: &cancellables)
        
        // Result Mute Unmute api
        viewModel.$getMuteUnmuteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    let isMuteStatus = response.data?.muteStatus ?? 0
                    print(response.message ?? "")
                    print(isMuteStatus,"isMuteStatus")
                    if isMuteStatus == 1 {
                        self.Arr[0] = "Unmute"
                        self.chatDataArr[self.index ?? 0].isMuted = 1
                    }
                    if isMuteStatus == 0 {
                        self.Arr[0] = "Mute"
                        self.chatDataArr[self.index ?? 0].isMuted = 0
                    }
                    
                })
            }.store(in: &cancellables)
        
        // Result Archive UnArchive api
        viewModel.$setArchiveResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    let isArchiveResult = response.data?.isArchived ?? false
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    print(isArchiveResult,"isArchiveResult")
                    if isArchiveResult == true {
                        self.Arr[4] = "Unarchive"
                        self.chatDataArr[self.index ?? 0].isArchived = 1
                    }
                    if isArchiveResult == false {
                        self.Arr[4] = "Archive"
                        self.chatDataArr[self.index ?? 0].isArchived = 0
                    }
                })
            }.store(in: &cancellables)
        
        // Result Mute Unmute api
        viewModel.$getDeleteChatResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.chatDataArr.remove(at: self.index ?? 0)
                    DispatchQueue.main.async {
                        self.tblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
}
